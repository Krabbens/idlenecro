# Architektura techniczna

## Baseline

- Silnik: Godot `4.7.x`; aktualnie zweryfikowany projekt działa na `4.7.2-stable`.
- Język: statycznie typowany GDScript.
- Gra: 2D, izometria 2:1, lokalny single-player, offline-first.
- Platformy v1: desktop oraz Android/iOS w orientacji landscape.
- Docelowy renderer: Compatibility, aby utrzymywać wspólną bazę PC/mobile. Projekt używa obecnie Forward Plus; jego zmiana jest osobnym, testowanym zadaniem konfiguracyjnym, nie częścią tworzenia dokumentacji.
- Referencyjny viewport UI: `1280×720`, stretch `canvas_items`, aspect `expand`; layout nie może zakładać stałego 16:9.

## Warstwy

```text
Presentation
  sceny, animacje, UI, audio, VFX
Application
  przebieg runu, encountery, nagrody, routing scen
Domain
  walka, statystyki, efekty, AI, losowość, offline reward
Data
  Resource definitions i katalog treści
Platform
  zapis, czas, ustawienia, input, integracje systemowe
```

Zależności płyną w dół. `Domain` nie odczytuje node’ów UI, animacji ani systemowego czasu. `Presentation` obserwuje stan i wysyła intencje aplikacyjne; nie wylicza obrażeń ani nagród.

## Docelowa struktura `res://`

```text
game/
  actors/
  combat/
  encounters/
  run/
  meta/
  world/
data/
  actors/
  abilities/
  encounters/
  items/
  balance/
ui/
  components/
  screens/
  themes/
platform/
  save/
  input/
  time/
assets/
tests/
  unit/
  integration/
  fixtures/
```

Folder grupuje pliki według funkcji gry, a nie rozszerzenia. Scena, skrypt i lokalne assety jednego komponentu mogą leżeć razem. Współdzielone dane i media mają własne katalogi.

## Kontrakty danych

Definicje są niemutowalnymi `Resource` ładowanymi przez rejestr treści. Stan runtime jest osobnym obiektem. Nigdy nie zapisuj bieżącego zdrowia, cooldownu lub pozycji w zasobie definicji.

### `ActorDefinition`

Minimalna odpowiedzialność:

- stabilne `id: StringName` i klucz lokalizacji;
- tagi frakcji, szkoły i roli;
- bazowe statystyki oraz footprint;
- lista `ability_ids` i id zestawu sprite’ów;
- dane AI, ale bez referencji do konkretnej sceny runu.

### `AbilityDefinition`

- stabilne `id`, tagi i typ celu;
- koszt, cooldown, timing kontaktu i zasady zasięgu;
- lista efektów domenowych;
- referencje prezentacyjne jako id, nie node’y runtime;
- opis budowany z tych samych parametrów, które wykorzystuje logika.

### `EncounterDefinition`

- `id`, biome, typ węzła i poziom trudności;
- fale/spawn groups, modyfikatory i tabela nagród;
- reguły zakończenia oraz seedowalne warianty;
- brak bezpośredniego zapisu postępu gracza.

### `RunState`

Obiekt runtime zawierający: wersję danych, seed, szkołę, bieżący rozdział i węzeł, build, Esencję, stan drużyny, historię decyzji i status zakończenia. `RunState` może być serializowany do wznowienia przerwanej aktywnej sesji, ale po zamknięciu gry nie wykonuje symulacji.

### `MetaProgress`

Trwałe odblokowania, Pył Grobowy, Pieczęcie, najwyższy potwierdzony postęp i odebrane jednorazowe nagrody. Nie zawiera ustawień użytkownika ani tymczasowych wartości runu.

### `SaveData`

Wersjonowana koperta zapisu:

```text
schema_version
content_version
meta_progress
suspended_run | null
settings
last_seen_utc
offline_claim_state
```

Każde nowe pole ma bezpieczną wartość migracyjną. Usunięcie lub zmiana znaczenia pola wymaga migracji i rekordu decyzji.

## Sceny i kompozycja

Docelowy root sceny gry:

```text
Game
  World
    GroundLayers
    Props
    Actors
    Projectiles
    WorldVFX
  CameraRig
  Systems
  UI
```

- Świat buduj z wielu `TileMapLayer`, rozdzielając podłoże, przeszkody, dekoracje i warstwy zakrywające.
- Aktor jest samodzielną sceną z jawnie przekazaną definicją i stanem; nie szuka globalnie przeciwników po nazwie node’a.
- Node odpowiada za lifecycle i prezentację. Reguły możliwe do przetestowania bez drzewa scen umieszczaj w typowanych obiektach domenowych.
- Używaj scen dziedziczonych oszczędnie. Preferuj składanie małych komponentów nad głębokie dziedziczenie.
- UI otrzymuje view model lub typowany stan, nie przeszukuje drzewa świata.

## Usługi globalne

Dopuszczalne autoloady muszą mieć jedną odpowiedzialność i mały publiczny interfejs:

- `SceneRouter` — kontrolowane przejścia scen;
- `SaveService` — odczyt, migracja, atomowy zapis i backup;
- `ContentRegistry` — walidowane mapowanie stabilnych id na definicje;
- `AudioService` — mikser, limity głosów i ustawienia globalne.

Nie twórz ogólnego `GameManager`, globalnego event busa ani autoloadu tylko po to, aby uniknąć przekazania zależności. Nowy autoload wymaga rekordu decyzji.

## Komunikacja

- Bezpośrednia, typowana referencja dla właściciela i bliskiej zależności.
- Sygnał w czasie przeszłym dla zdarzenia obserwowanego przez wiele komponentów, np. `encounter_completed`.
- Komenda/metoda dla intencji, np. `start_encounter(definition)`.
- Id treści na granicach zapisu i danych; referencja obiektu tylko w pamięci runtime.
- Sygnały nie mogą ukrywać krytycznej kolejności operacji. Zapis wyniku następuje jawnie po zatwierdzeniu transakcji nagrody.

## Deterministyczna symulacja

- Logika walki działa w stałym kroku `20 Hz`; rendering i interpolacja pozostają niezależne.
- Każdy run otrzymuje seed, a domena korzysta z przekazanego generatora RNG zamiast globalnych wywołań losowych.
- Kolejność aktualizacji jest stabilna: intencje → wybór celów → ruch → kontakty/obrażenia → efekty okresowe → śmierci/proci → zakończenie ticka.
- Jednostki i efekty posiadają stabilny runtime id używany do rozstrzygania remisów.
- Animacja, liczba FPS i prędkość odtwarzania nie zmieniają wyniku symulacji.
- Zmiana reguły deterministycznej zwiększa `content_version` albo wersję symulacji, jeśli wpływa na wznowione runy.

## Zapis i czas

- Główny zapis: `user://save.json`; zapis tymczasowy: `user://save.json.tmp`; ostatnia poprawna kopia: `user://save.backup.json`.
- Najpierw serializuj i zweryfikuj plik tymczasowy, potem podmień główny zapis. Nie nadpisuj jedynej poprawnej kopii przed walidacją.
- Odczyt przechodzi: parse → sprawdzenie wersji → migracje po kolei → walidacja semantyczna → publikacja stanu.
- Uszkodzony zapis nie może zostać automatycznie wyzerowany. Zachowaj go, spróbuj backupu i pokaż kontrolowany komunikat.
- Domenowy `TimeProvider` dostarcza UTC między sesjami oraz czas monotoniczny podczas sesji. Testy używają fake’a.
- Offline reward ogranicza czas do `0..8h`, nie symuluje `RunState` i staje się odebrany dopiero po poprawnym zapisie.

## Wydajność

- Cel: stabilne `60 FPS` na urządzeniu referencyjnym; gra pozostaje poprawna i czytelna przy `30 FPS` na urządzeniu słabszym.
- Profiluj na realnym urządzeniu mobilnym od pierwszego pionowego wycinka. Desktop nie jest dowodem wydajności mobile.
- Ogranicz przezroczyste pełnoekranowe warstwy, światła 2D, viewport textures i kosztowne postprocessy.
- Pooling wprowadzaj dopiero po profilu, dla często tworzonych pocisków/VFX. Nie przechowuj martwych obiektów bez limitu.
- Duże grupy jednostek aktualizuj w stałym ticku; prezentacja może pomijać nieistotne klatki, ale nie logikę.
- Każda funkcja zwiększająca liczbę aktorów, efektów lub draw calli otrzymuje scenariusz obciążeniowy w QA.

## Bezpieczeństwo zmian

- Zmiany publicznego kontraktu danych wymagają migracji, fixture starego zapisu i testu round-trip.
- Zmiana renderera, stretch mode, physics tick albo formatu importu jest osobnym zadaniem konfiguracyjnym z testem PC/mobile.
- Dodanie zewnętrznego pluginu lub biblioteki wymaga decyzji opisującej licencję, rozmiar, utrzymanie i sposób usunięcia.
- Nie edytuj generowanych plików `.godot/` i `.import` ręcznie.
