# Asset brief: `<asset_id>`

Status: `draft | review | approved | implemented | deprecated`

Właściciel: `<person_or_agent>`

Data: `<YYYY-MM-DD>`

## Identyfikacja

- `id`: `<stable_snake_case_id>`
- Typ: `<character | enemy | tile | prop | icon | portrait | ui | vfx | concept>`
- Przeznaczenie: `<gdzie i po co asset pojawia się w grze>`
- Finalna ścieżka: `<workspace path; wypełnić przed approval>`

## Specyfikacja techniczna

- Finalne wymiary/canvas: `<px>`
- Footprint: `<tile albo logical size>`
- Pivot: `<punkt kontaktu/koordynaty>`
- Perspektywa: `<2:1 isometric albo screen-space>`
- Kierunki: `<n, ne, e, se, s, sw, w, nw albo nie dotyczy>`
- Animacje i klatki: `<lista albo nie dotyczy>`
- Alpha/tło: `<transparent | opaque | tileable>`
- Ustawienia importu: `<filter, mipmaps, repeat, compression>`

## Specyfikacja artystyczna

- Rola/sylwetka: `<co ma być rozpoznane najpierw>`
- Materiały i faktury: `<lista>`
- Paleta/akcent: `<kolory i funkcja>`
- Oświetlenie: `<kierunek, twardość, nastrój>`
- Style anchor: `<path do zatwierdzonego oryginalnego obrazu albo nie dotyczy>`
- Czytelność: `<rozmiar, tło, test szarości>`

## Generowanie lub źródło

- Narzędzie/metoda: `<built-in image_gen | własna praca | licencjonowane źródło>`
- Tryb: `<generate | edit | nie dotyczy>`
- Obrazy wejściowe i role: `<Image 1: style reference; ... albo brak>`
- Prompt finalny: `<pełny prompt albo ścieżka do promptu>`
- Iteracja źródłowa: `<version/path>`
- Referencje i prawa: `<źródło, autor, licencja/uprawnienie>`
- Ograniczenia IP: `oryginalny projekt; bez cudzych marek, assetów, run, UI i znaków wodnych`

## Kryteria akceptacji

- [ ] Sylwetka realizuje funkcję i jest oryginalna.
- [ ] Skala, pivot, perspektywa i kierunek światła są zgodne z art bible.
- [ ] Asset jest czytelny w rozmiarze docelowym, w szarości i na właściwych tłach.
- [ ] Alpha/krawędzie nie mają halo ani artefaktów.
- [ ] Kierunki i klatki zachowują proporcje, wyposażenie i objętość.
- [ ] Pochodzenie oraz prawa są kompletne.
- [ ] Finalny plik znajduje się w workspace i przeszedł import/visual QA.

## Wynik QA

- Scena testowa: `<path>`
- Platformy/rozmiary: `<lista>`
- Zrzuty: `<paths>`
- Znane ograniczenia: `<brak albo jawna lista>`
