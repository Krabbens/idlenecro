# Game design

## Pętla nadrzędna

```text
Czarny Relikwiarz
  -> wybór szkoły, wyposażenia i rozdziału
  -> rozgałęziona mapa encounterów
  -> automatyczne starcie lub zdarzenie
  -> łup, dar albo decyzja o trasie
  -> eskalacja i boss
  -> podsumowanie, meta-progresja, powrót do hubu
```

Docelowy run trwa 15–25 minut. Ma trzy fazy intensywności: budowanie fundamentu, wymuszanie specjalizacji i test bossa. Długość wynika z liczby encounterów i tempa animacji, nie z długich timerów oczekiwania.

## Struktura rozdziału

Mapa jest skierowanym grafem. Po każdym węźle gracz widzi co najmniej dwie możliwe trasy, jeśli nie jest to finał. Typy węzłów v1:

| Typ | Identyfikator | Rola |
| --- | --- | --- |
| Walka | `combat` | podstawowy test buildu i źródło Esencji |
| Elita | `elite` | większe ryzyko, relikt lub dar wyższej rzadkości |
| Rytuał | `ritual` | transformacja jednostki, zdolności albo zasobu za koszt |
| Zdarzenie | `event` | krótki wybór z jawnym ryzykiem i konsekwencją |
| Relikwiarz | `reliquary` | zakup lub wymiana opcji runu |
| Boss | `boss` | test dominującej synergii i finał rozdziału |

Mapa nie ukrywa podstawowego typu nagrody. Losowość zmienia treść węzła, ale nie może unieważniać informacji pokazanej przed wyborem trasy.

## Walka automatyczna

- Jednostki samodzielnie wybierają cele, poruszają się, atakują i używają umiejętności według danych oraz jawnych priorytetów AI.
- Gracz nie steruje ruchem ani nie posiada aktywnych przycisków zdolności w v1.
- Dostępne sterowanie podczas walki: pauza, prędkość `1×/2×`, inspekcja jednostki oraz podgląd źródeł obrażeń i efektów.
- Build ma odpowiadać na archetyp encounteru: horda, opancerzony cel, nacisk dystansowy, obrażenia obszarowe, boss fazowy.
- Boss używa czytelnych zapowiedzi, ale odpowiedzią jest przygotowanie buildu i pozycjonowanie AI, nie refleks gracza.
- Porażka kończy run. Ekran podsumowania wskazuje główne źródła otrzymanych obrażeń, niewykorzystane synergie i najskuteczniejsze jednostki.

## Cztery szkoły

### Władca Grobów — `grave_caller`

Fantazja: dowódca licznej, wymiennej hordy. Rdzeń stanowią przywołania, wzmacnianie liczebności i efekty aktywowane śmiercią sługi. Słabością są obrażenia obszarowe oraz ograniczona przestrzeń.

### Tkacz Krwi — `blood_weaver`

Fantazja: ryzyko zamieniane w tempo. Wydaje zdrowie lub żywotność sług, tworzy więzi krwi i odzyskuje zasoby przez agresję. Słabością jest przerwanie rytmu leczenia i nagłe obrażenie.

### Strażnik Kości — `bone_warden`

Fantazja: wolna, twarda formacja. Buduje pancerz, bariery, kolce i kontrataki. Słabością są przeciwnicy ignorujący obronę oraz presja czasu.

### Herold Zarazy — `plague_herald`

Fantazja: skażenie przechodzące między celami. Nakłada obrażenia okresowe, osłabienia i reakcje łańcuchowe. Słabością są pojedyncze cele oczyszczające efekty oraz powolny start.

Każda szkoła musi mieć własny język mechaniczny, kolor akcentu i rozpoznawalny kształt armii. Wspólne zdolności nie mogą usuwać jej słabości bez istotnego kosztu.

## Warstwy progresji

### W runie

- `essence` / Esencja: waluta encounterów; wydawana w rytuałach i relikwiarzach; resetowana po runie.
- dary: wybór jednej z trzech opcji po kluczowych walkach; resetowane po runie.
- relikty: przedmioty zmieniające reguły lub tworzące synergie; aktywne do końca runu.
- poziomy jednostek i modyfikatory rozdziału: tymczasowe.

### Pomiędzy runami

- `grave_dust` / Pył Grobowy: podstawowy zasób meta zdobywany za postęp, pierwsze zwycięstwa i nagrodę offline.
- `sigils` / Pieczęcie: znaczniki pokonania bossów i bramy nowych rozdziałów; nigdy nie są naliczane offline.
- odblokowania: nowe zdolności, relikty, warianty sług i opcje startowe trafiają do puli przyszłych runów.
- ulepszenia meta mają poszerzać opcje lub łagodzić start; nie mogą zastępować jakości buildu nieograniczonym wzrostem mnożników.

Nie istnieje waluta premium w kanonie v1.

## Nagroda offline

Nagroda offline nalicza wyłącznie Pył Grobowy według ostatniego potwierdzonego poziomu postępu. Domyślny limit wynosi 8 godzin.

Zasady:

- zapis przechowuje `last_seen_utc` i wersję schematu;
- czas jest ograniczany do zakresu `0..8h`; cofnięcie zegara daje zero, nie wartość ujemną;
- nagroda nie tworzy przedmiotów, Pieczęci, losowych encounterów ani wyniku runu;
- ekran powrotu pokazuje czas zaliczony, zastosowany limit, stawkę i wynik;
- naliczenie staje się trwałe dopiero po atomowym zapisie odebranej nagrody;
- dokładna stawka jest danymi balansowymi, a nie stałą zaszytą w UI.

## Zasady losowości i balansu

- Każdy run posiada jawny seed zapisany w `RunState`.
- Ta sama wersja danych, seed i sekwencja decyzji muszą dać ten sam wynik logiki symulacji.
- Losowanie nagrody najpierw filtruje opcje nielegalne, potem stosuje wagi. Nie losuje w pętli aż do znalezienia poprawnej wartości.
- Wybór trzech darów nie może zawierać duplikatów ani trzech opcji bez związku z aktualnym buildem, jeśli istnieją legalne synergie.
- Rzadkość zwiększa specjalizację lub zmienia regułę; nie jest jedynie większą liczbą.
- Każdy boss sprawdza co najmniej dwa aspekty buildu i posiada co najmniej jedną słabość możliwą do wykorzystania przez każdą szkołę.

## Biome’y v1

- Popielne Krypty — `ashen_crypts`: ciasne przejścia, kruche grobowce, ogień żałobny.
- Zatopione Ossuarium — `drowned_ossuary`: chłodne kanały, odbicia, jednostki spowalniające i flankujące.
- Ogrody Zgnilizny — `rot_gardens`: organiczne przeszkody, zarodniki, rozrastające się strefy zagrożenia.

Każdy biome ma własne materiały, sylwetki i mechaniczny motyw, ale używa wspólnej geometrii izometrycznej i tego samego języka czytelności.

## Granice projektowe

- Brak energii blokującej rozpoczęcie runu.
- Brak nagrody wymagającej oglądania reklamy.
- Brak ręcznego mikrozarządzania każdą jednostką.
- Brak niewidocznych kar za zamknięcie aplikacji.
- Brak nieskończonego skalowania liczb bez nowych zachowań przeciwników.
