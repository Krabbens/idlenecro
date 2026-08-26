# Pipeline assetów

Ten proces obejmuje koncepty, sprite’y, tile’e, propsy, portrety, ikony, elementy UI i bitmapowe VFX. O generowaniu decyduje rodzaj rezultatu: bitmapy można tworzyć przez ImageGen, ale SVG, fonty, layouty i proste elementy kodowe należy budować deterministycznie.

## Struktura docelowa

```text
art_source/
  .gdignore
  briefs/
  anchors/
  working/
assets/
  characters/
  enemies/
  environments/
  items/
  ui/
  vfx/
```

`art_source/` przechowuje mastery, briefy, style anchory i robocze warianty, których Godot nie powinien importować. `assets/` zawiera tylko zatwierdzone pliki używane przez projekt. Foldery zostaną utworzone dopiero przy pierwszym zadaniu assetowym.

## Nazwy i wersje

- Używaj `snake_case` i stabilnego id z briefu.
- Roboczy wariant: `<id>_<purpose>_v001.png`, np. `grave_caller_concept_v003.png`.
- Klatka animacji: `<actor>_<animation>_<direction>_<frame>.png`, np. `bone_guard_move_ne_03.png`.
- Zatwierdzony plik konsumpcyjny ma stabilną nazwę; jego źródło i wersja pozostają w briefie.
- Nie nadpisuj istniejącego assetu podczas eksploracji. Utwórz kolejny numer wersji albo jawny wariant `-edited`.

Statusy: `draft` → `review` → `approved` → `implemented` → `deprecated`. Tylko `approved` może wejść do `assets/`.

## Obowiązkowy brief

Przed generowaniem skopiuj [templates/asset_brief.md](templates/asset_brief.md) do `art_source/briefs/<id>.md` i wypełnij:

- `id`, typ, status i przeznaczenie w grze;
- finalne wymiary, footprint, pivot i oczekiwane warianty;
- perspektywę, kierunki i wymagane animacje/klatki;
- paletę, materiał, oświetlenie i czytelność;
- prompt, role obrazów wejściowych i listę ograniczeń;
- referencje wraz z prawem użycia;
- narzędzie, datę, wersję źródła i finalną ścieżkę.

Nie generuj bez kryteriów akceptacji. „Ma wyglądać dobrze” nie jest kryterium.

## Workflow ImageGen

### 1. Wybierz tryb

- Użyj wbudowanego `image_gen` dla zwykłego generowania, edycji i przezroczystego tła. Nie wymaga klucza API.
- CLI jest fallbackiem tylko wtedy, gdy użytkownik jawnie wybierze ścieżkę CLI/API/model. Nie przechodź na niego dla samej kontroli rozmiaru lub ścieżki.
- Wiele różnych assetów oznacza osobne wywołanie dla każdego assetu. Wiele wariantów jednego briefu również wykonuj jako osobne, nazwane iteracje.

### 2. Określ intencję wejść

Każdy obraz wejściowy oznacz jedną rolą:

- `style reference` — wskazuje paletę, materiał albo kompozycję;
- `edit target` — ma zostać zmieniony przy zachowaniu wymienionych cech;
- `supporting input` — dostarcza element do kompozytu.

Lokalny cel edycji obejrzyj najpierw przez `view_image`. Style anchor projektu jest referencją, nie celem edycji, chyba że brief mówi inaczej.

### 3. Zbuduj prompt

Użyj [templates/image_prompt.md](templates/image_prompt.md). Kolejność informacji: scena/tło → temat → szczegóły → kompozycja → światło/paleta → ograniczenia → zastosowanie.

- Dla assetów gry używaj `Use case: stylized-concept`.
- Dla zachowania postaci między ilustracjami używaj edycji `identity-preserve` i powtarzaj niezmienniki.
- Dla wycięcia tła używaj `background-extraction` i żądaj prawdziwego kanału alpha.
- Jeśli prompt jest szczegółowy, porządkuj go bez dopisywania fabuły. Jeśli jest ogólny, dodaj tylko informacje potrzebne do produkcji.
- Nie używaj nazw cudzych gier, marek, artystów ani chronionych postaci. Opisz cechy: `dark original isometric low-resolution painted fantasy`, materiały, proporcje i światło.

### 4. Generuj i iteruj

1. Najpierw generuj koncept albo style anchor, nie finalny sprite sheet.
2. Obejrzyj wynik: temat, sylwetkę, perspektywę, światło, paletę, tekst, artefakty i listę `Avoid`.
3. W kolejnej iteracji zmień jedną rzecz. Dla edycji ponownie wypisz wszystkie niezmienniki.
4. Dla elementu z alpha sprawdź rzeczywistą przezroczystość, krawędzie i brak halo.
5. Odrzucony wariant może pozostać roboczy; wybrany wariant zapisz w workspace i wpisz do briefu.

Wbudowane narzędzie zapisuje wynik domyślnie w obszarze generowanych obrazów Codex. Asset używany przez projekt trzeba skopiować do workspace; projekt nie może wskazywać zewnętrznej ścieżki. Po zadaniu raportuj finalną ścieżkę i prompt.

### 5. Przekształć do assetu produkcyjnego

ImageGen jest narzędziem koncepcyjnym i źródłem bitmapy, nie gwarancją gotowego sprite sheeta. Przed zatwierdzeniem:

- usuń tło i artefakty, zachowując czysty alpha;
- dopasuj perspektywę 2:1, kierunek światła i rozmiar względem style anchora;
- zredukuj obraz do docelowej skali kontrolowanym procesem, a potem wykonaj ręczną korektę pikseli;
- wyrównaj pivot i bounding box wszystkich klatek;
- sprawdź stałą objętość, ekwipunek i liczbę kończyn w każdym kierunku;
- rozdziel animację na klatki i atlas dopiero po akceptacji pojedynczych klatek;
- zachowaj master w `art_source/working/`, a finalny PNG w `assets/`.

## Pipeline według typu

### Postać lub przeciwnik

1. Brief sylwetki i funkcji w walce.
2. Jedna plansza konceptowa bez tła.
3. Zatwierdzony style anchor przodu i izometrycznego kierunku `se`.
4. Osiem kierunków neutralnego `idle`, ocenionych jako komplet.
5. Animacje w kolejności: `idle`, `move`, `attack/cast`, `hit`, `death`.
6. Pivot, timing, test w szarości i test na trzech tłach biome’u.

### Tile i prop

1. Footprint w tile’ach i oznaczenie powierzchni przechodniej.
2. Wariant bazowy zgodny z diamentem `128×64 px`.
3. Krawędzie, narożniki i warianty przejścia bez widocznego szwu.
4. Cień na osobnej warstwie, jeśli prop może zmieniać oświetlenie.
5. Test powtórzenia minimum `5×5` i test sąsiedztwa z innym materiałem.

### Ikona

1. Jedna dominująca sylwetka, bez tekstu i sceny tła.
2. Master `256×256 px` z bezpiecznym marginesem.
3. Ocena przy `64×64 px`, w szarości i na jasnej/ciemnej ramce.
4. Kolor szkoły jest akcentem, nie jedynym nośnikiem znaczenia.

### UI

ImageGen może dostarczyć koncept i bitmapową fakturę. Finalne panele buduj z `Control`, `NinePatchRect`, fontów i osobnych ikon. Nie importuj obrazu całego ekranu jako funkcjonalnego UI i nie wypalaj tekstu w grafice.

## Import do Godot

Domyślne ustawienia dla sprite’ów, tile’i i ikon low-res:

- kompresja bezstratna;
- `Filter: Off`;
- `Mipmaps: Off`;
- `Repeat: Disabled`, chyba że brief jawnie wymaga tekstury powtarzalnej;
- bez automatycznej redukcji rozmiaru;
- alpha bez jasnego obramowania i bez premultiplikowanego halo.

Po imporcie sprawdź asset w scenie testowej, przy skali docelowej i na urządzeniu mobilnym. Zmiana ustawień importu należy do pliku `.import`/presetu projektu, nie do ręcznej poprawki każdego użycia.

## Pochodzenie i IP

Każdy asset musi mieć udokumentowane źródło. Dozwolone są: własna generacja, własna praca, asset z licencją zgodną z projektem albo materiał dostarczony przez użytkownika z potwierdzonym prawem użycia.

Niedozwolone:

- kopiowanie lub wycinanie assetów z komercyjnej gry;
- używanie logo, fontu, runy, postaci lub layoutu rozpoznawalnego jako cudza marka;
- wpisywanie nazwy marki lub żyjącego artysty jako skrótu stylu w prompt produkcyjny;
- brak zapisu promptu, źródła referencji albo warunków licencji;
- pozostawienie finalnego assetu wyłącznie poza workspace.

## Checklista akceptacji

- Brief jest kompletny i ma status `approved`.
- Asset spełnia wymiary, pivot, kierunek, alpha i paletę.
- Jest czytelny w rozmiarze docelowym, w szarości i na właściwym tle.
- Animacja nie zmienia objętości ani ekwipunku między klatkami.
- Import nie generuje ostrzeżeń i nie wymaga per-node hacków.
- Pochodzenie, prompt, referencje i prawa są zapisane.
- Finalna ścieżka w workspace jest podana w raporcie.
