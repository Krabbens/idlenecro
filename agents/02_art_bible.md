# Art bible

## Rdzeń wizualny

`IdleNecro` łączy mroczne, materialne fantasy z czytelnością gry strategicznej. Obraz ma przypominać ręcznie dopracowaną ilustrację o niskiej rozdzielczości: twarda sylwetka, ograniczona liczba wartości tonalnych, widoczna faktura i oszczędne, precyzyjne światło.

Słowa-klucze: grobowy, popielny, rytualny, zużyty, wilgotny, ciężki, cichy, czytelny.

Niepożądane: błyszczący high fantasy, kreskówkowe proporcje, neon na całym ekranie, fotorealistyczny szum, przypadkowe detale, czarna plama bez hierarchii, bezpośrednia imitacja cudzej marki.

## Kamera i geometria

- Rzut 2D izometryczny o proporcji diamentu `2:1`.
- Bazowy tile podłoża: `128×64 px`; logiczny środek i pivot muszą być identyczne w całym tilesecie.
- Kamera jest stała. Nie obraca się i nie zmienia kąta projekcji.
- Wysokość obiektu wyraża się pionowym przesunięciem grafiki nad punktem styku z ziemią, nie zmianą geometrii tile’a.
- Każdy aktor ma pivot w punkcie kontaktu stóp lub podstawy z podłożem.
- Kolejność świata: podłoże → warianty/decale → niskie propsy → aktorzy i pociski → ściany/korony zakrywające → atmosferyczne VFX → UI.
- Głębia wynika z kontrolowanego `y_sort`, warstw wysokości i jawnych wyjątków. Ręczne `z_index` nie może maskować błędnego pivotu.

## Skala assetów

| Asset | Standard roboczy |
| --- | --- |
| tile podłoża | `128×64 px` |
| ściana/duży prop | wielokrotność footprintu tile’a, pivot na gruncie |
| zwykły aktor | klatka do `256×256 px`, dużo przezroczystego marginesu tylko gdy wymaga go animacja |
| duży przeciwnik/boss | klatka do `512×512 px`, osobny budżet VFX |
| ikona zdolności/reliktu | master `256×256 px`, walidacja również przy `64×64 px` |
| portret | master `512×512 px`, twarz czytelna przy `128×128 px` |

Rozmiar canvasa nie określa rozmiaru postaci. Sylwetka ma respektować wspólną skalę świata i footprint danych jednostki.

## Paleta i światło

Paleta świata opiera się na węglu, zimnym kamieniu, utlenionym metalu, kości i przygaszonej ziemi. Kolor nasycony oznacza informację: szkołę, interakcję, zagrożenie albo nagrodę.

| Funkcja | Kolor orientacyjny |
| --- | --- |
| najciemniejsze tło | `#111318` |
| kamień bazowy | `#252932` |
| metal | `#56606a` |
| kość/tekst jasny | `#d6c7a1` |
| ogień żałobny | `#c56a3d` |
| `grave_caller` | `#70a8a1` |
| `blood_weaver` | `#9d2f43` |
| `bone_warden` | `#d2b56b` |
| `plague_herald` | `#7d9b4a` |

Kolory są kotwicami, nie zamkniętą paletą. Każdy asset przechodzi test w skali szarości. Domyślne światło kluczowe pada z lewego górnego kierunku ekranu. Cień kontaktowy jest krótki i mocny; cień kierunkowy może być miękki, ale nie może przesuwać odczytu pivota.

## Sylwetki szkół

- `grave_caller`: pionowa, szczupła sylwetka dowódcy otoczona wieloma małymi, trójkątnymi sługami; chłodne światło dusz.
- `blood_weaver`: miękkie łuki, wiszące nici i naczynia; akcenty karmazynu skupione blisko centrum ciała.
- `bone_warden`: szeroka podstawa, warstwowe płyty, łuki żeber i jasne krawędzie kości.
- `plague_herald`: asymetria, obwisłe tkaniny, pęcherze i chmury o nieregularnym obrysie; zieleń używana punktowo.

Przy wyłączonym kolorze szkoły nadal muszą być rozpoznawalne po proporcjach i rytmie animacji.

## Animacje

Grywalne postacie i główni przeciwnicy używają ośmiu kierunków: `n`, `ne`, `e`, `se`, `s`, `sw`, `w`, `nw`. Lustrzane odbicie jest dozwolone tylko wtedy, gdy brief potwierdza brak asymetrycznego ekwipunku, światła i symboli.

Minimalny zestaw aktora v1:

- `idle`: 4–6 klatek;
- `move`: 6–8 klatek;
- `attack` albo `cast`: 6–10 klatek z jawną klatką kontaktu;
- `hit`: 2–4 klatki, bez przesadnego zatrzymania całej walki;
- `death`: 8–12 klatek i stabilna klatka końcowa.

Logika nigdy nie odczytuje momentu obrażeń z wyglądu klatki. Dane umiejętności definiują czas kontaktu, a animacja go wizualizuje. Wszystkie klatki zachowują pivot, skalę, kierunek światła i objętość postaci.

## Biome’y

### Popielne Krypty

Suchy kamień, spękana ceramika, sadza i pomarańczowy ogień żałobny. Kształty są kanciaste, a przejścia ciasne. Tło ma niższy kontrast niż aktorzy.

### Zatopione Ossuarium

Zielonkawy kamień, czarna woda, miedź i chłodne refleksy. Odbicia są uproszczone i nie mogą podwajać VFX zagrożeń.

### Ogrody Zgnilizny

Brunatna ziemia, kościane podpory, matowe błony i punktowa zieleń zarodników. Organiczne dekoracje nie mogą wyglądać jak aktywne strefy obrażeń bez właściwego telegraphu.

## UI

- Rama wizualna: ciemne żelazo, stara kość, matowy mosiądz i wypłowiały pergamin.
- Informacja dominuje nad ornamentem. Dekoracja nie przecina tekstu, progress bara ani hit targetu.
- Panele używają `NinePatchRect`, kontenerów i skalowalnej typografii; pełnoekranowy obraz panelu nie jest layoutem.
- Ikony mają mocny kontur, jedną dominantę i nie zawierają tekstu.
- Tekst oraz liczby są renderowane przez UI, nie wypalane w generowanym obrazie.
- Kolor rzadkości zawsze ma drugi kanał: kształt ramki, znak albo etykietę.

Szczegóły responsywności i dostępności określa [07_ui_mobile_accessibility.md](07_ui_mobile_accessibility.md).

## VFX

- Jedno ważne zdarzenie ma jeden dominujący język efektu: kierunek, pierścień, impuls lub chmurę.
- VFX sojuszniczy i wrogi różnią się kształtem oraz rytmem, nie tylko kolorem.
- Efekt nie może zasłonić pivota, paska zdrowia bossa ani zapowiedzi następnego ataku.
- Przy wielu procach efekty łączą się lub ograniczają częstotliwość; nie nakładają bez limitu.
- Opcja `reduced_vfx` usuwa cząstki wtórne, bloom i drgania, zachowując telegraph oraz moment kontaktu.

## Audio

- Muzyka: niskie drony, suche instrumenty akustyczne, oddech przestrzeni i oszczędna perkusja. Bez cytatów melodii i instrumentacji identyfikującej inną markę.
- Priorytet miksu: telegraph bossa → potwierdzenie wyboru → obrażenia gracza → zdolność szkoły → ambience → efekty hordy.
- Każda szkoła ma krótki motyw materiałowy: szept dusz, puls krwi, trzask kości albo wilgotny rozpad.
- Duża liczba podobnych zdarzeń używa limitu głosów i wariantów wysokości, aby uniknąć ściany dźwięku.
- Gra zapewnia osobne suwaki `master`, `music`, `sfx`, `ui` i `ambience`.

## Do / nie rób

Rób:

- oceniaj asset w rzeczywistym rozmiarze i na tle biome’u;
- używaj oryginalnych style anchorów zatwierdzonych dla projektu;
- utrzymuj konsekwentny pivot, kierunek światła i skalę;
- pokazuj najważniejszą informację sylwetką, potem kolorem i efektem.

Nie rób:

- nie wpisuj nazw cudzych gier ani artystów do promptu produkcyjnego;
- nie kopiuj run, pentagramów, ramek, fontów lub układu HUD z referencji;
- nie akceptuj wygenerowanego sprite sheeta bez kontroli każdej klatki;
- nie ukrywaj nieczytelności pod bloomem, mgłą albo czernią;
- nie mieszaj kierunków światła pomiędzy klatkami i assetami.
