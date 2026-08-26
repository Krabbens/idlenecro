# QA i Definition of Done

Jakość jest częścią implementacji. „Działa u mnie” oznacza początek weryfikacji, nie jej koniec.

## Warstwy testów

### Testy domenowe

Uruchamiane bez renderowania sceny. Obejmują:

- obrażenia, pancerz, efekty okresowe i kolejność proców;
- target selection i stabilne rozstrzyganie remisów;
- seedowane losowanie mapy, darów i nagród;
- limit nagrody offline, cofnięcie zegara i wielokrotne odebranie;
- serializację, migracje i round-trip zapisu;
- walidację definicji oraz brakujące id.

### Testy integracyjne

Sprawdzają współpracę sceny, danych i usług:

- start encounteru z fixture;
- zakończenie walki, wybór nagrody i zapis wyniku;
- wznowienie przerwanego runu;
- przejście hub → mapa → walka → podsumowanie;
- reakcję UI na zmianę stanu i brak mutacji domeny przez prezentację.

### Scene smoke

Każda główna scena musi się otworzyć, przejść `_ready`, wykonać podstawową interakcję i zamknąć bez `Error`, orphan node’ów i brakujących zasobów.

### QA wizualne

Wymagane dla UI, świata, animacji, VFX i assetów:

- zrzut referencyjny PC oraz mobile;
- ocena w rozmiarze docelowym, nie tylko w powiększeniu;
- pivot, sorting i kolizje przy nakładających się aktorach;
- czytelność intensywnej walki, skala szarości i `reduced_vfx`;
- porównanie z kryteriami briefu, nie z przypadkowym „ładniej/gorzej”.

### Wydajność

Każdy pionowy wycinek ma scenariusz typowy i stresowy. Mierz:

- średni i najgorszy frame time CPU/GPU;
- liczbę aktorów, pocisków, cząstek i draw calli;
- czas wejścia do runu i powrotu do hubu;
- pamięć przed runem, podczas szczytu i po zakończeniu;
- czas zapisu, odczytu i migracji.

Nie optymalizuj na podstawie samego FPS. Zapisz urządzenie, build, scenariusz i profil.

## Macierz v1

| Profil | Ekran/input | Obowiązkowe kontrole |
| --- | --- | --- |
| Desktop referencyjny | `1920×1080`, mysz/klawiatura | 60 FPS, hover/focus, resize, zapis |
| Desktop wąski | `1280×800`, mysz/klawiatura | aspect expand, tekst 130%, brak obcięć |
| Mobile szeroki | około `20:9`, dotyk, landscape | safe area, tap/scroll, suspend/resume |
| Mobile 16:9 | dotyk, landscape | minimalne hit targety, czytelność walki |
| Mobile słaby | dotyk | co najmniej 30 FPS, reduced VFX, pamięć |

Android jest minimalnym urządzeniem fizycznym dla bieżącej iteracji. iOS musi przejść tę samą listę przed wydaniem na iOS; brak urządzenia należy jawnie zgłosić, nie oznaczyć jako zaliczone.

## Krytyczne scenariusze regresji

### Determinizm

Ten sam seed, wersja danych i sekwencja decyzji dwukrotnie dają identyczną mapę, kolejność nagród i wynik logiki walki. FPS i prędkość animacji nie zmieniają wyniku.

### Offline reward

- `-1h` różnicy zegara → `0h` nagrody;
- `4h` → dokładnie cztery godziny stawki;
- `12h` → cap `8h`;
- dwukrotne otwarcie ekranu → nagroda naliczona raz;
- błąd zapisu → brak potwierdzenia odbioru i możliwość ponowienia.

### Zapis

- bieżąca wersja round-trip bez utraty danych;
- każdy wspierany stary fixture migruje krok po kroku;
- uszkodzony główny zapis nie kasuje backupu;
- nieznane id treści daje kontrolowany błąd z kontekstem.

### Horda

Największy wspierany encounter nie gubi śmierci, proców ani targetów, nie pozostawia node’ów po powrocie do hubu i utrzymuje budżet słabego mobile.

## Definition of Done funkcji

Funkcja jest gotowa dopiero, gdy:

- spełnia zapisane kryteria akceptacji oraz kanon produktu;
- kontrakty danych i owner stanu są jawne;
- happy path, przypadki brzegowe i regresja mają właściwy test;
- scena lub projekt uruchamia się bez nowych błędów i istotnych ostrzeżeń;
- zmiana widoczna ma zrzuty/visual QA dla PC i mobile;
- wpływ na wydajność został zmierzony albo świadomie uznany za nieistotny z uzasadnieniem;
- zapis/migracja są przetestowane, jeśli zmienia się trwały stan;
- input mysz i dotyk mają parytet;
- dokument domenowy, fixture i brief zostały zaktualizowane;
- raport wymienia zmienione pliki, testy, ograniczenia i pozostałe ryzyka.

## Definition of Done assetu

- brief posiada status `approved`, prompt, pochodzenie i prawa;
- finalny plik leży w workspace i nie nadpisuje niezatwierdzonego wariantu;
- pivot, skala, kierunek światła, alpha i nazwa są zgodne;
- asset przechodzi test rozmiaru docelowego, tła, szarości i mobile;
- animacja przechodzi kontrolę każdej klatki;
- import nie tworzy brakujących zależności ani ostrzeżeń;
- koszt pamięci i atlasu mieści się w budżecie sceny.

## Definition of Done dokumentacji

- wszystkie linki wewnętrzne wskazują istniejące pliki/anchory;
- `grave_caller`, `blood_weaver`, `bone_warden`, `plague_herald`, `128×64`, `15–25` i cap `8h` nie mają sprzecznych definicji;
- nie ma nieprzypisanego `TBD`, `TODO`, `FIXME` ani `HACK`;
- przykład nie przeczy zasadzie opisanej obok;
- nowy dokument znajduje się w mapie [README](README.md);
- read-only `gdmcp doctor` i `editor state` potwierdzają baseline albo dokument zawiera aktualizację.

## Narzędzia testowe

W repo nie ma jeszcze frameworka testowego. Do czasu świadomego wyboru używaj małego, projektowego runnera uruchamianego headless dla czystej logiki oraz scen smoke dla integracji. Dodanie zewnętrznego frameworka wymaga [rekordu decyzji](templates/decision_record.md), oceny licencji i testu działania w CI oraz Godot 4.7.x.
