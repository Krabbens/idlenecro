# Workflow Git/GitHub

Ten dokument jest kanonicznym źródłem zasad dostarczania zmian przez Git, GitHub i Beads. Obowiązuje razem z [playbookiem agenta](09_agent_playbook.md), a skrót operacyjny w `AGENTS.md` nie zastępuje poniższych reguł.

## Cel i granice

Każda zmiana ma mieć rozpoznawalny zakres, właściciela, dowody jakości i ślad w historii Git. Repozytorium używa chronionego `main`, pośredniej gałęzi integracyjnej dla milestone'u oraz krótkotrwałych branchy pojedynczych beadów.

Nie zmieniaj kanonu produktu, publicznego kontraktu zapisu, zasad assetów ani ochrony `main` bez odpowiedniego decision recordu i beada decyzyjnego. Nie przenoś do tego workflow niezwiązanych zmian znalezionych w working tree.

## Drzewo branchy

```text
main                           # release, chroniony
└── integration/<milestone>    # integracja, CI i wspólne QA
    ├── feat/<bead-id>-<slug>  # nowa funkcja
    ├── fix/<bead-id>-<slug>   # poprawka błędu
    └── chore/<bead-id>-<slug> # dokumentacja, proces, tooling
```

W tym repozytorium bieżącą gałęzią pośrednią jest `integration/vertical-slice`.

| Poziom | Odpowiedzialność | Dozwolony kierunek zmian |
| --- | --- | --- |
| `main` | stabilny release i punkt odniesienia | wyłącznie PR z integracji |
| `integration/<milestone>` | składanie zaakceptowanych beadów, CI, QA i wykrywanie konfliktów | PR z brancha zadania |
| `feat/`, `fix/`, `chore/` | jeden bead, jeden zakres, jeden właściciel | branch integracyjny jako base |

Nie twórz równoległych `develop`, `staging`, `tmp` ani prywatnych gałęzi bez decyzji w Beads. Branch zadania nie celuje bezpośrednio do `main`; wyjątek wymaga jawnej decyzji awaryjnej, wpisu w Beads i — jeśli zmienia zasady projektu — ADR.

## Przepływ zadania

1. Utwórz lub znajdź bead, zapisz kryteria akceptacji i przejmij pracę przez `bd update <bead-id> --claim`.
2. Zapisz baseline: `git status --short`, bieżący branch, remotes oraz pliki zmienione wcześniej przez użytkownika. Te pliki są poza zakresem, chyba że bead jawnie je obejmuje.
3. Utwórz branch zadania od integracji. Preferowany wariant z osobnym worktree:

   ```bash
   git worktree add ../idlenecro-<bead-id> -b <type>/<bead-id>-<slug> integration/vertical-slice
   ```

   W istniejącym worktree użyj `git switch -c <type>/<bead-id>-<slug> integration/vertical-slice` tylko po sprawdzeniu, że nie przenosisz cudzych zmian do innego zakresu.

4. Zaimplementuj najmniejszy kompletny zakres beada i aktualizuj dokument źródłowy właściwej domeny.
5. Przed commitem uruchom odpowiednie testy, świeżą inspekcję logów, visual QA oraz walidację dokumentacji. Dla zmian Godot użyj gdmcp; dla zmian procesu/CI wystarczą testy właściwe dla dokumentacji i konfiguracji.
6. Zacommituj wyłącznie reviewed scope, wypchnij branch zadania i otwórz PR do `integration/vertical-slice`, jeśli użytkownik lub polityka repozytorium wymaga PR.
7. Po akceptacji PR integracja przechodzi CI, wspólne QA i kontrolę konfliktów. Dopiero wtedy otwórz osobny PR `integration/vertical-slice` → `main`.
8. Po merge do `main` zaktualizuj Beads o hash, testy, QA i ograniczenia; zamknij bead dopiero po spełnieniu jego kryteriów. Merge, release i zamknięcie beada są odrębnymi czynnościami.

## Zasady commitów

Commit jest atomowy i opisuje jedną logiczną zmianę. Subject używa imperatywnego [Conventional Commits](https://www.conventionalcommits.org/) i ma maksymalnie 72 znaki, np.:

```text
fix(ui): improve bitmap font readability (idlenecro-ywy.4.1)
```

Body commita opisuje problem, decyzję i weryfikację. Dodaj `Refs: <bead-id>`; `Closes:` stosuj tylko wtedy, gdy commit faktycznie kończy zadanie. Nie mieszaj refaktoru, formatowania, assetów i zmian produktu w jednym commicie bez uzasadnienia.

Nie używaj `git add .`, `git add -A` ani `git commit -a`. Stage'uj jawne ścieżki lub hunki:

```bash
git add -- path/to/file-a path/to/file-b
git diff --cached
git diff --cached --check
git commit -m "type(scope): imperative summary"
git show --stat --oneline --decorate HEAD
```

Przed commitem sprawdź, czy staged diff nie zawiera sekretów, cache, plików tymczasowych, niezwiązanych zmian ani wygenerowanych plików bez ich źródła.

## GitHub, CI i PR

- Pushuj nazwany branch przez `git push -u origin <branch>` po kontroli staged diffu. Nie rób force-push i nie pushuj bezpośrednio na chroniony `main`.
- CI uruchamia się na push do `main` i `integration/**` oraz na PR. Zielony CI jest warunkiem promocji integracji.
- PR do integracji zawiera podsumowanie, zakres beada, testy, visual QA, ograniczenia i link do beada.
- PR integracji do `main` zawiera listę zintegrowanych zmian, wynik wspólnego QA i potwierdzenie braku nowych błędów w logach.
- Otwieranie PR, merge, release i zmiany ustawień ochrony branchy wymagają osobnej autoryzacji; samo polecenie wykonania commita nie oznacza zgody na merge.

## Praca na zastanym working tree

Przed każdą zmianą odróżnij baseline od zakresu beada. Nie nadpisuj, nie resetuj i nie usuwaj istniejących zmian użytkownika. Jeśli plik obejmuje jednocześnie zakres beada i wcześniejsze zmiany, wystage'uj tylko własny hunk albo zatrzymaj pracę z jawnym raportem konfliktu zakresów.

W raporcie końcowym podaj:

- branch i hash commita;
- pliki objęte commitem;
- komendy testów, wynik CI, logi i visual QA, jeśli dotyczy;
- ograniczenia i niezweryfikowane platformy;
- status PR, merge i beada.

## Definition of Done workflowu

Workflow jest wykonany, gdy:

1. bead ma kryteria, właściciela i zapisane dowody;
2. branch zadania wynika z właściwej gałęzi integracyjnej;
3. commit jest atomowy, opisany i przechodzi `git diff --cached --check`;
4. testy i CI odpowiadają zakresowi zmiany;
5. branch został wypchnięty bez naruszenia `main` ani cudzych zmian;
6. PR, merge i zamknięcie beada mają właściwy status i raport.
