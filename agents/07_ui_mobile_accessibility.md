# UI, mobile i dostępność

## Założenia layoutu

- Referencyjny viewport: `1280×720` logical pixels.
- Obsługiwane proporcje v1: od `16:10` do `21:9`, w tym typowe ekrany z wycięciem.
- Orientacja mobilna: wyłącznie landscape w v1.
- Layout używa `Container`, anchors, size flags i tematów. Pozycje absolutne są dozwolone dla elementów świata, nie dla całego HUD.
- Rozszerzaj obraz świata do dostępnego aspektu; nie rozciągaj UI ani sprite’ów.
- Elementy krytyczne muszą pozostawać wewnątrz safe area. Dekoracyjne tło może sięgać pod wycięcie.

## Hierarchia ekranów

### Walka

Priorytety od najwyższego:

1. stan bohatera i bossa;
2. aktywne zagrożenie oraz telegraph;
3. pauza i prędkość;
4. skrócony stan buildu;
5. liczby wtórne, log i statystyki.

HUD podczas walki ma być spokojny. Szczegółowe tooltipy i analiza są dostępne po pauzie. Na mobile nie pokazuj stale panelu, który zasłania więcej niż jedną trzecią pola walki.

### Wybór nagrody

- Zatrzymuje symulację.
- Pokazuje trzy karty o równej wadze wizualnej.
- Każda karta zawiera nazwę, typ, efekt liczbowy, tagi synergii i informację o zastępowanej opcji.
- Wybór wymaga jednego potwierdzenia; nie stosuj małego osobnego checkboxa.
- Przed potwierdzeniem można porównać wpływ na statystyki.

### Mapa rozdziału

- Typ węzła i podstawowa klasa nagrody są widoczne przed wyborem.
- Klikalny obszar obejmuje symbol i etykietę.
- Niedostępna gałąź ma opis przyczyny, nie tylko szary kolor.

### Hub

Hub dzieli na osobne ekrany: wybór szkoły, wyposażenie, odblokowania, rozdziały, ustawienia. Nie twórz jednego panelu z wszystkimi systemami.

## Mysz i dotyk

Każda podstawowa czynność ma równoważny input:

| Czynność | Mysz/klawiatura | Dotyk |
| --- | --- | --- |
| wybór | kliknięcie | tap |
| szczegóły | hover lub focus | tap/hold albo jawny przycisk info |
| przewijanie | wheel/drag | swipe |
| zamknięcie | `Esc`/przycisk | przycisk back |
| pauza | `Space`/przycisk | przycisk pauzy |

Hover nie może być jedynym sposobem odkrycia informacji. Krytyczna akcja nie zależy od gestu wielopalcowego.

- Minimalny cel dotykowy: `48×48` logical pixels.
- Minimalny odstęp między dwoma niebezpiecznymi celami: `8` logical pixels.
- Gest zaczęty na scroll containerze nie aktywuje karty po przekroczeniu progu przeciągnięcia.
- Stan `pressed`, `focused`, `disabled` i `selected` różni się kształtem lub obrysem, nie tylko kolorem.
- Sterowanie padem nie jest zakresem v1, lecz node’y UI nie mogą uniemożliwiać przyszłej nawigacji focus.

## Typografia i lokalizacja

- Tekst podstawowy: minimum `16` logical pixels przy skali `100%`.
- Kluczowe wartości walki: minimum `18`; nagłówki używają wyraźnej hierarchii, nie samych kapitalików.
- Użytkownik może ustawić skalę tekstu co najmniej `100%`, `115%`, `130%`.
- Komponenty muszą wytrzymać tekst dłuższy o `30%` bez obcięcia znaczenia.
- Liczby używają spójnego formatowania skrótów i tooltipa z pełną wartością.
- Tekst nie jest częścią bitmapy. Obrazy mogą zawierać wyłącznie znaki będące elementem świata, nie komunikaty UI.

## Kontrast i kolor

- Tekst podstawowy osiąga co najmniej kontrast `4.5:1`; duży tekst i ikony interaktywne co najmniej `3:1` względem tła.
- Stan sojusznik/wróg, rzadkość, szkoła i typ obrażeń posiadają drugi kanał: kształt, wzór, ikonę lub etykietę.
- Tryb wysokiego kontrastu wzmacnia obrysy telegraphów, pasków i fokusu bez zmiany zasad gry.
- Testuj protanopię, deuteranopię i tritanopię na zrzutach z intensywnej walki oraz ekranie nagród.

## Ruch, błyski i komfort

Ustawienia v1:

- `screen_shake`: off / reduced / full;
- `reduced_vfx`: wyłącza cząstki wtórne i intensywny postprocess;
- `damage_numbers`: off / important / all;
- `animation_speed`: nie zmienia czasu symulacji ani długości okna decyzyjnego;
- osobne poziomy głośności zgodnie z [art bible](02_art_bible.md#audio).

Nie stosuj błysku pełnoekranowego. Powtarzający się efekt nie może przekraczać trzech wyraźnych błysków na sekundę. Ważny telegraph pozostaje widoczny przy `reduced_vfx`.

## Wydajność mobile

- UI nie tworzy nowych materiałów per instancja bez potrzeby.
- Długie listy używają recyclingu lub stronicowania po potwierdzeniu problemu profilem.
- Blur, viewport texture i pełnoekranowe przezroczystości wymagają testu na urządzeniu słabym.
- Aktualizuj etykietę tylko, gdy wartość się zmieniła; nie formatuj wszystkich liczb w każdej klatce.
- Safe area, input dotykowy i powrót z uśpienia testuj na realnym Androidzie/iOS przed release.

## Checklista ekranu

- Działa przy `1280×720`, szerokim telefonie i ekranie `16:10`.
- Wszystkie funkcje są dostępne bez hovera.
- Cele dotykowe mają minimum `48×48` i nie kolidują z safe area.
- Tekst przy `130%` nie zasłania akcji i zachowuje pełne znaczenie.
- Kluczowy stan jest czytelny w skali szarości i symulacji zaburzeń widzenia barw.
- Focus, pressed, disabled, selected i błąd są rozróżnialne.
- `reduced_vfx`, wyłączone drgania i suwaki audio działają natychmiast.
- Zrzuty PC i mobile zostały porównane z kryteriami funkcji.
