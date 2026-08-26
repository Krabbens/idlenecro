# Wizja produktu

## Jednozdaniowa obietnica

`IdleNecro` to mroczny, izometryczny roguelike auto-battler, w którym gracz buduje jedną z czterech szkół nekromancji, dowodzi automatycznie walczącą hordą i podejmuje krótkie, znaczące decyzje pomiędzy starciami.

## Fantazja gracza

Świat po Zgaśnięciu utracił naturalny obieg śmierci. Dusze osiadają w ruinach, ciała nie wracają do ziemi, a prowincje zmieniają się w żywe nekropolie. Gracz jest Archontem Czarnego Relikwiarza: nie bohaterem walczącym z nekromancją, lecz strażnikiem, który używa jej czterech szkół, aby przywrócić równowagę.

Ta przesłanka ma być oryginalna. Nazwy, heraldyka, postacie, biome’y i konflikty nie mogą odtwarzać fabuły ani ikonografii istniejących marek.

## Odbiorca

- Lubi budowanie synergii, automatyczną walkę i krótkie sesje z wyraźnym finałem.
- Chce obserwować konsekwencje wcześniejszych decyzji zamiast wykonywać zręcznościową rotację umiejętności.
- Ceni mroczne fantasy, ale oczekuje czytelnego obrazu i interfejsu również na telefonie.
- Gra na PC myszą lub na urządzeniu mobilnym dotykiem, najczęściej w orientacji poziomej.

## Filary produktu

### Dowodzenie, nie klikanie

Walka realizuje wcześniej zbudowaną strategię. Gracz wybiera szkołę, skład hordy, relikty, dary i trasę. Podczas starcia może pauzować, zmieniać prędkość i oglądać szczegóły, lecz w v1 nie steruje ruchem ani nie aktywuje ręcznie umiejętności.

### Krótkie runy, długie odkrywanie

Rozdział trwa 15–25 minut i zawsze zmierza do bossa. Kolejne runy poszerzają pulę możliwości, a nie tylko mnożą liczby. Porażka ma dostarczać informacji o buildzie, nie odbierać godzin postępu.

### Horda, którą da się przeczytać

Na ekranie może walczyć wiele jednostek, ale najważniejsze zagrożenie, stan bohatera i wynik synergii muszą pozostać zrozumiałe bez zatrzymywania gry.

### Mrok z kontrolowanym kontrastem

Świat jest posępny, zużyty i materialny. Kluczowe jednostki, interakcje oraz VFX używają kontrolowanych akcentów barwnych. Ciemność nie może ukrywać informacji potrzebnej do decyzji.

### Offline bez fikcyjnego runu

Gra może naliczyć ograniczony zasób meta po nieobecności. Nie rozgrywa bez gracza walk, nie wybiera darów, nie generuje reliktów i nie powoduje porażki runu.

## Zakres v1

Wersja v1 obejmuje:

- jednego gracza, działanie offline-first i lokalny zapis;
- cztery szkoły: `grave_caller`, `blood_weaver`, `bone_warden`, `plague_herald`;
- Czarny Relikwiarz jako hub;
- rozgałęzione rozdziały z walkami, elitami, zdarzeniami, rytuałami i bossem;
- co najmniej trzy wizualnie odrębne biome’y;
- tymczasowy build runu, trwałe odblokowania meta i limitowaną nagrodę offline;
- sterowanie myszą i dotykiem oraz układ landscape dla PC, Androida i iOS;
- zapis wersjonowany i migracje danych od pierwszej publicznej wersji.

Poza v1 pozostają: multiplayer, bezpośrednie sterowanie bohaterem, pełna symulacja offline, orientacja portretowa, system reklam, sklep premium i backend wymagający konta. Włączenie któregoś elementu wymaga osobnej decyzji produktowej.

## Miary jakości

- Nowy gracz rozumie w ciągu pierwszej minuty, że walka jest automatyczna, a jego rolą jest budowanie synergii.
- Każdy wybór daru potrafi uzasadnić wpływem na aktualny build.
- Stan walki pozostaje czytelny na mobilnym ekranie bez opierania się wyłącznie na kolorze.
- Pełny run ma początek, eskalację i finał w zakładanym czasie.
- Powrót po nieobecności daje korzyść, ale nie przewyższa aktywnej gry i nie podejmuje decyzji za gracza.

## Granica inspiracji

[OpenDiablo2](https://github.com/OpenDiablo2/OpenDiablo2) jest referencją historyczną dla izometrycznej czytelności klasycznego ARPG, nie biblioteką treści. Repozytorium tego projektu samo nie dostarcza chronionych assetów Diablo. W `IdleNecro` wolno analizować ogólne cechy — perspektywę, warstwy głębi, wagę sylwetki, rytm animacji — ale nie wolno kopiować assetów, layoutu UI, run, nazw, melodii, fabuły ani rozpoznawalnych projektów.
