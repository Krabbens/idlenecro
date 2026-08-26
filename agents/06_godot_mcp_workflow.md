# Workflow Godot MCP

`gdmcp` jest podstawowym interfejsem agenta do działającego edytora Godot. Uruchamiaj go z katalogu projektu, aby automatycznie wykrył `project.godot` i ustawienia połączenia.

## Zweryfikowany baseline

Stan sprawdzony 2026-08-26:

- CLI: `./.gdmcp/bin/gdmcp`;
- Godot: `4.7.2-stable (official)`;
- plugin MCP: `1.0.7`;
- edytor połączony;
- brak aktywnej sceny gry i brak uruchomionego runtime;
- jedyną sceną w projekcie jest panel dodatku MCP.

Jeśli lokalny plik CLI nie istnieje, dopiero wtedy użyj `gdmcp` z `PATH`. Nigdy nie drukuj `GODOT_MCP_TOKEN`.

## Obowiązkowy cykl

```text
doctor
  -> inspekcja aktualnego stanu
  -> wąska zmiana
  -> uruchomienie lub odświeżenie
  -> logi i runtime
  -> test/visual QA
  -> raport i aktualizacja dokumentacji
```

### 1. Diagnoza

```bash
./.gdmcp/bin/gdmcp --json doctor
./.gdmcp/bin/gdmcp --json editor state
./.gdmcp/bin/gdmcp --json scenes current
./.gdmcp/bin/gdmcp --json debug logs --level Error --limit 50
```

Jeżeli `editor_connected` jest `false`, nie zgaduj stanu sceny. Zgłoś blokadę lub wykonaj wyłącznie pracę niewymagającą edytora.

### 2. Wąska inspekcja

```bash
./.gdmcp/bin/gdmcp --json scenes list --limit 20
./.gdmcp/bin/gdmcp --json scenes tree --depth 4
./.gdmcp/bin/gdmcp --json nodes list --limit 30
./.gdmcp/bin/gdmcp --json scripts list --limit 30
./.gdmcp/bin/gdmcp --json scripts read res://path/to/file.gd --lines 1:200
./.gdmcp/bin/gdmcp --json resources list --limit 30
./.gdmcp/bin/gdmcp --json resources get res://path/to/file.tres --fields resource_path,resource_name
./.gdmcp/bin/gdmcp --json project settings --filter display/
```

Zawsze ograniczaj wynik przez `--limit`, `--depth`, `--fields`, `--lines` lub `--max-bytes`. Nie pobieraj kompletnego katalogu narzędzi ze schematami.

Rozwiązuj nazwę do stabilnej ścieżki przed mutacją:

```bash
./.gdmcp/bin/gdmcp --json nodes resolve Player
./.gdmcp/bin/gdmcp --json scenes resolve Main
./.gdmcp/bin/gdmcp --json scripts resolve player
./.gdmcp/bin/gdmcp --json resources resolve actor_definition
```

### 3. Zmiana

- Preferuj domenowe komendy `scenes`, `nodes`, `scripts` i `resources` nad surowym `tool-call`.
- Przed destrukcyjną operacją ponownie odczytaj dokładny cel.
- Destrukcyjna domenowa komenda i surowy destrukcyjny `tool-call` wymagają jawnego `--apply`.
- Batch zawsze przechodzi `batch preview`, a dopiero potem `batch apply --apply`.
- Batch jest sekwencyjny i nieatomowy. Po częściowej porażce sprawdź każdą wykonaną operację; nie zakładaj rollbacku.

Przykład bezpiecznego batcha:

```bash
./.gdmcp/bin/gdmcp --json batch preview ./operations.json
./.gdmcp/bin/gdmcp --json batch apply ./operations.json --apply
```

Jeśli brakuje wąskiej komendy, odkrywaj progresywnie:

```bash
./.gdmcp/bin/gdmcp --json tools search "runtime shader parameter" --limit 5
./.gdmcp/bin/gdmcp --json tools schema set_runtime_shader_parameter
./.gdmcp/bin/gdmcp --json tool-call set_runtime_shader_parameter --args-file ./request.json --allow-open-world
```

Nie twórz pliku argumentów w repo, jeśli zawiera sekret lub jest jednorazowym artefaktem; użyj bezpiecznego katalogu tymczasowego.

### 4. Runtime i logi

Po uruchomieniu gry:

```bash
./.gdmcp/bin/gdmcp --json runtime info
./.gdmcp/bin/gdmcp --json runtime tree --depth 4
./.gdmcp/bin/gdmcp --json runtime nodes get /root/Game
./.gdmcp/bin/gdmcp --json debug logs --limit 50
```

Narzędzia otwartego runtime wymagają `--allow-open-world`. Logi czytaj stronicami przez `--cursor`, jeśli pierwsza strona nie obejmuje momentu błędu. Nie uznawaj zadania za poprawne tylko dlatego, że scena się uruchomiła.

### 5. Weryfikacja

- Sprawdź brak nowych `Error` i istotnych `Warning`.
- Obejrzyj scenę w docelowym rozmiarze PC i mobile, jeśli zmiana jest widoczna.
- Potwierdź ścieżki zasobów, node’y runtime i wartości krytycznego stanu.
- Uruchom test domenowy, integracyjny lub smoke odpowiedni do zmiany.
- Po błędzie odczytaj świeży stan zamiast powtarzać mutację w ciemno.

## Przepisy

### Zmiana skryptu

1. `scripts resolve` i `scripts read` dla zakresu, który ma się zmienić.
2. Sprawdzenie scen i zasobów korzystających ze skryptu.
3. Wąska edycja; pełne zastąpienie tylko po przeczytaniu całego pliku.
4. Reload/uruchomienie sceny, logi, test logiki i kontrola runtime.

### Refaktor node’a

1. `scenes current`, `scenes tree`, `nodes get` z potrzebnymi polami.
2. Rozwiąż node do pełnej ścieżki.
3. Wykonaj jedną operację move/rename.
4. Ponownie odczytaj drzewo i sprawdź zależne ścieżki oraz logi.

### Problem widoczny tylko podczas gry

1. Uruchom minimalny scenariusz reprodukcji.
2. Pobierz `runtime info`, ograniczone drzewo i konkretny node.
3. Przeczytaj log od zapamiętanego kursora.
4. Zapisz faktyczny stan i dopiero wtedy zmień kod.
5. Powtórz identyczny scenariusz i porównaj wynik.

## Zakazy

- Nie używaj MCP do przypadkowego eksplorowania całego katalogu narzędzi.
- Nie wykonuj mutacji na nazwie niezamienionej na stabilną ścieżkę.
- Nie uruchamiaj destrukcyjnej komendy bez inspekcji, preview tam gdzie dostępny i `--apply`.
- Nie zakładaj, że batch jest transakcją.
- Nie pozostawiaj działającej gry lub zmienionego stanu edytora bez sprawdzenia logów.
- Nie pokazuj tokenów, danych użytkownika ani pełnych zapisów w wyjściu narzędzia.
