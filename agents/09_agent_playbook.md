# Playbook agenta

## Zasada przewodnia

Najpierw ustal prawdę o projekcie, potem wykonaj najmniejszą zmianę realizującą kryteria, a na końcu dostarcz dowody. Nie zastępuj inspekcji założeniami ani testu opisem.

## Dostarczanie przez Git/GitHub

Git jest częścią Definition of Done, a nie czynnością porządkową po implementacji. Pełny, kanoniczny opis znajduje się w [Workflow Git/GitHub](10_git_github_workflow.md). Ten playbook definiuje kolejność pracy agenta; dokument workflow definiuje gałęzie, commity, CI, PR i promocję do `main`.

## Cykl zadania

### 1. Przyjęcie

- Streść cel jako obserwowalne zachowanie.
- Określ odbiorcę, platformy, dane trwałe i granice zadania.
- Przeczytaj dokument wizji oraz dokumenty domenowe wskazane w [README](README.md).
- Jeśli zadanie zmienia kanon, przygotuj [decision record](templates/decision_record.md) przed implementacją.

### 2. Inspekcja

- Sprawdź pliki przez `rg`/`rg --files` oraz aktualny stan edytora przez [gdmcp](06_godot_mcp_workflow.md).
- Znajdź właściciela stanu, istniejący kontrakt danych, sceny konsumenckie i testy.
- Odczytaj pełny plik przed jego pełnym zastąpieniem.
- Zapisz ryzyka: zapis, migracja, deterministyczność, mobile, assety, wydajność.

### 3. Specyfikacja

Utwórz roboczą kopię [feature_spec.md](templates/feature_spec.md) albo [asset_brief.md](templates/asset_brief.md). Każde kryterium ma być testowalne. Pole nieistotne oznacz „nie dotyczy” z jednym zdaniem uzasadnienia; nie zostawiaj placeholderu w aktywnym dokumencie.

### 4. Implementacja

- Zbuduj najmniejszy pionowy wycinek przechodzący przez dane, domenę i prezentację tylko tam, gdzie jest to potrzebne.
- Nie refaktoruj niezwiązanych modułów i nie dodawaj zależności „na przyszłość”.
- Zachowaj zmiany użytkownika oraz istniejące pliki spoza zakresu.
- Nowe id i ścieżki są stabilne, angielskie i zgodne ze standardem.
- Dla assetu stosuj [pipeline assetów](03_asset_pipeline.md); dla projektu Godot wykonuj wąskie operacje i ponowną inspekcję.

### 5. Weryfikacja

- Uruchom najwęższy test odtwarzający zachowanie, następnie właściwy smoke/integrację.
- Sprawdź logi od momentu uruchomienia scenariusza.
- Wykonaj visual QA dla każdej widocznej zmiany i macierz PC/mobile, jeśli wpływa na layout albo input.
- Sprawdź zapis/migrację dla trwałego stanu oraz seed dla losowości.
- Przejdź odpowiednią checklistę [Definition of Done](08_qa_definition_of_done.md).

### 6. Utrzymanie wiedzy

- Zaktualizuj jeden właściwy dokument źródłowy zamiast kopiować regułę do kilku miejsc.
- Dodaj decyzję, gdy zmienił się kontrakt lub świadomie wybrano odstępstwo.
- Usuń robocze placeholdery i jednorazowe pliki.
- Nie oznacz znanego ograniczenia jako błąd „przyszłego agenta”; przypisz je do konkretnego zadania albo zgłoś użytkownikowi.

### 7. Raport

Raport końcowy prowadzi od wyniku:

1. co działa i jaki cel spełnia;
2. najważniejsze zmienione pliki/kontrakty;
3. uruchomione testy, logi i visual QA;
4. ograniczenia, których nie udało się zweryfikować;
5. bezpieczny następny krok tylko wtedy, gdy wnosi wartość.

## Macierz aktualizacji dokumentów

| Zmiana | Dokument obowiązkowy |
| --- | --- |
| filar, platforma, zakres v1 | `00_product_vision.md` |
| pętla, szkoła, ekonomia, offline | `01_game_design.md` |
| paleta, animacja, UI look, audio | `02_art_bible.md` |
| format, prompt, import, licencja assetu | `03_asset_pipeline.md` i brief |
| typ danych, warstwa, save schema, autoload | `04_technical_architecture.md` i decision record |
| konwencja kodu | `05_coding_standard.md` |
| nowa operacja edytora/runtime | `06_godot_mcp_workflow.md` |
| layout, input, dostępność | `07_ui_mobile_accessibility.md` |
| test, urządzenie, DoD | `08_qa_definition_of_done.md` |

## Scenariusz A: nowa zdolność

Przykład: `bone_spikes` dla `bone_warden`.

1. Przeczytaj game design, architekturę, standard kodu i QA.
2. Zdefiniuj zachowanie, target, timing kontaktu, tagi, koszt i kryteria deterministyczne.
3. Sprawdź istniejące `AbilityDefinition`, efekty domenowe i rejestr id; nie twórz równoległego systemu.
4. Dodaj definicję danych i tylko brakujące zachowanie domenowe.
5. Dodaj test obrażeń, cooldownu, kolejności proców, legalnego celu i identycznego wyniku dla tego samego seeda.
6. Podłącz prezentację przez id VFX/audio, nie przez logikę animacji.
7. Uruchom encounter fixture przez Godot, sprawdź logi i czytelność na PC/mobile.
8. Zaktualizuj opis szkoły tylko wtedy, gdy zmienia jej kanoniczną rolę.

Wynik nie jest gotowy, jeśli animacja wygląda dobrze, ale timing obrażeń zależy od FPS albo brak id powoduje cichy fallback.

## Scenariusz B: nowy sprite przeciwnika

1. Przeczytaj art bible, pipeline assetów i asset DoD.
2. Utwórz brief z rolą w walce, footprintem, skalą, pivotem, ośmioma kierunkami i animacjami.
3. Użyj wyłącznie oryginalnych referencji lub style anchora projektu; zapisz ich role i prawa.
4. Wbudowanym ImageGen utwórz koncept, obejrzyj go i iteruj pojedynczą zmianą. Nie generuj od razu „gotowego” sprite sheeta.
5. Zatwierdź sylwetkę oraz kierunek `se`, potem wyprowadź pozostałe kierunki i animacje.
6. Wyczyść alpha, wyrównaj klatki, pivot, światło i objętość; zapisz master oraz finalne pliki w workspace.
7. Zaimportuj bez filtrowania/mipmap, uruchom scenę testową, sprawdź sorting i trzy tła biome’u.
8. Wykonaj zrzut w rozmiarze docelowym i mobile; wpisz prompt, narzędzie, wersję i ścieżkę do briefu.

Wynik nie jest gotowy, jeśli asset istnieje tylko w katalogu generowanych obrazów, nie ma źródła albo pojedyncza klatka zmienia ekwipunek postaci.

## Scenariusz C: responsywny panel mobile

1. Przeczytaj dokument UI, art bible, standard kodu i QA.
2. Zapisz hierarchię informacji oraz działanie myszą i dotykiem.
3. Zbuduj komponent z `Container`, stylebox/NinePatch i tekstem runtime; nie używaj zrzutu ekranu jako panelu.
4. Zapewnij hit target `48×48`, stany focus/pressed/disabled oraz brak zależności od hovera.
5. Sprawdź `1280×720`, `1280×800`, szeroki telefon z safe area i skalę tekstu `130%`.
6. Sprawdź kontrast, szarość, trzy symulacje widzenia barw i `reduced_vfx`.
7. Przetestuj scroll kontra tap, zamknięcie, suspend/resume oraz brak błędów w logach.
8. Do raportu dołącz zrzuty PC/mobile i niezweryfikowaną platformę, jeśli brak urządzenia.

Wynik nie jest gotowy, jeśli dotyk działa wyłącznie dzięki emulacji myszy, tekst jest wypalony w grafice albo panel zasłania krytyczny telegraph.

## Zakazy operacyjne

- Nie zmieniaj kanonu z powodu łatwiejszej implementacji bez decyzji.
- Nie instaluj pluginu, frameworka lub generatora bez oceny potrzeby, licencji i kosztu usunięcia.
- Nie edytuj `project.godot`, ustawień importu lub save schema jako efektu ubocznego innego zadania.
- Nie usuwaj ani nie nadpisuj pracy użytkownika, roboczego assetu i jedynego poprawnego zapisu.
- Nie deklaruj testu platformy, której faktycznie nie uruchomiono.
- Nie kończ zadania ze świeżym błędem w logu lub niewypełnionym kryterium bez jawnego raportu.
