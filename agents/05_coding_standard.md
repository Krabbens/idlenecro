# Standard kodowania

Standard rozszerza oficjalny [GDScript style guide](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_styleguide.html) oraz [project organization](https://docs.godotengine.org/en/latest/tutorials/best_practices/project_organization.html). Spójność z istniejącym modułem ma pierwszeństwo tylko wtedy, gdy nie narusza poniższych reguł architektonicznych.

## Format i nazwy

- UTF-8, LF, jedna końcowa nowa linia.
- Wcięcia: tabulator, zgodnie z domyślnym formatem Godot.
- Docelowo do 100 znaków w linii; łam wcześniej, gdy poprawia to czytelność.
- Pliki, foldery, funkcje, zmienne i sygnały: `snake_case`.
- Klasy i node’y: `PascalCase`.
- Stałe i wartości enum: `CONSTANT_CASE`; nazwa enum w `PascalCase` i liczbie pojedynczej.
- Prywatne pola i metody zaczynają się pojedynczym `_`.
- Id treści to stabilny angielski `StringName`, nigdy przetłumaczony display name.

Sygnał opisuje fakt w czasie przeszłym:

```gdscript
signal health_changed(previous: int, current: int)
signal actor_died(actor_id: int)
```

Metoda opisuje intencję w trybie czynnościowym:

```gdscript
func apply_damage(request: DamageRequest) -> DamageResult:
```

## Typowanie

- Typuj parametry, wartości zwrotne, pola publiczne, kolekcje i sygnały.
- Używaj `:=`, gdy typ prawej strony jest jednoznaczny i nie prowadzi do niechcianego `Variant`.
- Unikaj słowników jako długowiecznych kontraktów. Dla danych domenowych twórz nazwany `Resource`, `RefCounted` albo mały value object.
- `Variant` jest dozwolony na granicy serializacji lub API Godot; waliduj i konwertuj go natychmiast.
- Nie koduj rodzaju obiektu w nazwie zmiennej (`player_node`, `data_dict`), jeśli typ już to wyjaśnia.

```gdscript
class_name Health
extends RefCounted
## Kontroluje bieżące i maksymalne zdrowie jednego aktora.

signal changed(previous: int, current: int)
signal depleted

var current: int
var maximum: int


func _init(initial_maximum: int) -> void:
	assert(initial_maximum > 0, "maximum health must be positive")
	maximum = initial_maximum
	current = initial_maximum


func apply_damage(amount: int) -> int:
	if amount <= 0 or current == 0:
		return 0

	var previous := current
	current = maxi(0, current - amount)
	changed.emit(previous, current)

	if current == 0:
		depleted.emit()

	return previous - current
```

## Porządek pliku

1. `@tool`, `@icon`, `@static_unload`;
2. `class_name`;
3. `extends`;
4. komentarz dokumentacyjny `##`;
5. sygnały, enumy, stałe;
6. pola statyczne, `@export`, publiczne, prywatne, `@onready`;
7. `_static_init`, metody statyczne;
8. callbacki Godot w kolejności lifecycle;
9. publiczny interfejs;
10. metody prywatne.

Grupuj kod odpowiedzialnością, nie regionami o setkach linii. Jeśli skrypt łączy logikę walki, zapis i prezentację, rozdziel odpowiedzialności zamiast dodawać kolejne sekcje.

## Sceny i zależności

- Eksportuj zależność tylko wtedy, gdy designer ma ją świadomie ustawić w inspectorze.
- Dla wymaganego child node używaj unikalnej nazwy albo jawnej ścieżki blisko właściciela; waliduj ją w `_ready`.
- Nie używaj `get_tree().get_first_node_in_group()` jako ukrytego service locatora dla logiki domenowej.
- Nie odwołuj się do node’a przez jego display name z innego modułu.
- Preferuj kompozycję scen i małe komponenty nad bazową klasą zawierającą wszystkie możliwe zachowania.
- Instancja otrzymuje definicję i stan przed rozpoczęciem symulacji. `_ready` nie losuje treści ani nie odczytuje zapisu.

## Sygnały i stan

- Sygnał nie jest substytutem wartości zwrotnej. Wynik operacji zwracaj jako typ, a sygnału użyj do powiadomienia obserwatorów.
- Nie łącz sygnału do anonimowego callable, jeśli połączenie trzeba później bezpiecznie odpiąć.
- UI może subskrybować stan, ale nie zapisuje go bezpośrednio.
- Jedna klasa jest właścicielem mutacji danego stanu. Pozostałe wysyłają intencję.
- Nie umieszczaj stanu runtime w `Resource` współdzielonym przez wiele instancji.

## Obsługa błędów

- `assert` służy wyłącznie do niezmienników programisty w buildzie deweloperskim.
- Błąd treści lub wejścia użytkownika obsłuż kontrolowanie: zwróć wynik, zapisz kontekst przez `push_error` i nie kontynuuj z częściowo poprawnym stanem.
- Nie łap błędu przez pusty fallback. Jeśli brak assetu ma placeholder, log musi podać oczekiwane id i ścieżkę, a placeholder nie może trafić do release bez zgłoszenia.
- Operacja zapisu ma wynik sukces/porażka. UI potwierdza nagrodę dopiero po sukcesie.
- Komunikat zawiera działanie i identyfikator: `Failed to load AbilityDefinition 'bone_spikes'`, nie samo `Load failed`.

Przykład walidacji kontraktu:

```gdscript
func resolve_ability(id: StringName) -> AbilityDefinition:
	var definition := _abilities.get(id) as AbilityDefinition
	if definition == null:
		push_error("Unknown AbilityDefinition '%s'" % id)
	return definition
```

Wywołujący musi sprawdzić `null`; w krytycznym procesie inicjalizacji rejestr treści powinien wcześniej odrzucić brak id.

## Komentarze i dokumentacja

- Komentarz wyjaśnia „dlaczego”, ograniczenie albo nieoczywisty invariant. Nie tłumaczy składni.
- Publiczne typy, sygnały i metody używane poza modułem otrzymują `##` z kontraktem oraz skutkami ubocznymi.
- Workaround zawiera warunek usunięcia oraz link/id decyzji lub problemu.
- Zakazane są nieprzypisane `TODO`, `FIXME`, `HACK` i `TBD`. Użyj identyfikatora zadania albo napraw problem w bieżącym zakresie.
- Zmiana zachowania gracza wymaga aktualizacji właściwego dokumentu w `agents/`.

## Losowość, czas i liczby

- RNG i czas wstrzykuj przez interfejs/provider. Nie używaj globalnego losowania ani `Time` bezpośrednio w domenie.
- Jednostki nazywaj w identyfikatorze: `_seconds`, `_ticks`, `_pixels`, `_percent`.
- Czas symulacji zapisuj jako całkowite ticki; czas ścienny zapisu jako UTC Unix seconds.
- Wartości balansowe należą do zasobów danych, nie do skryptu prezentacji.
- Porównania floatów stosują tolerancję tam, gdzie wynik nie jest dokładny.

## Wydajność bez przedwczesnej komplikacji

- Najpierw poprawność i profil, potem optymalizacja.
- Nie wykonuj wyszukiwań po całym drzewie w `_process` lub ticku symulacji.
- Buforuj wymagane zależności i używaj kolekcji indeksowanych stabilnym id.
- Nie twórz stringów i obiektów w gorącej pętli, jeśli profiler pokazuje istotną alokację.
- Pool ma limit, resetuje cały stan i posiada test ponownego użycia.

## Testowalność

- Logika obrażeń, efektów, RNG, nagród i migracji ma działać bez renderowania sceny.
- Każda naprawa błędu najpierw otrzymuje test odtwarzający problem.
- Test nazywaj zachowaniem, np. `test_offline_reward_is_capped_at_eight_hours`.
- Fixture ma minimalny zakres i stabilne id; nie korzysta z przypadkowych danych całej gry.
- Test nie zależy od kolejności uruchomienia ani prawdziwego zegara.

## Przegląd kodu

Sprawdź kolejno: zgodność z kanonem, właściciela stanu, granice warstw, deterministyczność, migracje, obsługę błędów, testy, koszt mobile i czytelność. Formatowanie jest ostatnią kontrolą, nie substytutem projektu.
