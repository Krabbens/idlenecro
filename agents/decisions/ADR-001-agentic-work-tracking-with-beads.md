# Decision record: agentowe zarządzanie pracą przez Beads

Id: `ADR-001`

Status: `accepted`

Data: `2026-08-26`

Decydenci: `właściciel projektu i agent implementujący`

## Kontekst

IdleNecro jest na początku implementacji: repozytorium nie miało historii Git,
nie ma jeszcze kodu gry ani scen produkcyjnych, a praca obejmuje wiele zależnych
epików Godot, danych, assetów i QA. Klasyczny tracker webowy utrudniałby agentowi
atomowe pobieranie gotowej pracy i zachowanie kontekstu między sesjami.

## Decyzja

Od 2026-08-26 używamy Beads CLI `>=1.1.0,<2.0` jako jedynego trackera zadań
deweloperskich. Dane Beads są przechowywane przez Dolt, a synchronizacja między
klonami używa remote Git. Integracja Codex działa przez `bd setup codex` i CLI;
serwer MCP nie jest wymagany w środowisku z dostępem do shella. Telemetria Beads
jest wyłączona.

Agenci mogą autonomicznie claimować, implementować, testować, commitować,
pushować i zamykać zadania po spełnieniu Definition of Done. Zmiana kanonu,
zakresu v1, licencji, praw do assetów lub operacja wymagająca konta/zakupu musi
zostać osobnym bead-em decyzyjnym.

## Rozważone opcje

### Beads

- Korzyści: graf zależności, `bd ready --claim`, audit trail, Dolt sync, praca offline i integracja Codex.
- Koszty/ryzyka: CLI wymaga instalacji; brak klasycznego webowego panelu Jiry; migracje wersji Beads trzeba kontrolować.

### Plane self-hosted

- Korzyści: pełny webowy tracker, REST API i MCP.
- Koszty/ryzyka: serwer, baza, utrzymanie i dodatkowa granica synchronizacji dla obecnego jednoosobowego repozytorium.

### Backlog.md

- Korzyści: prosty lokalny Kanban, Markdown i MCP.
- Koszty/ryzyka: słabszy graf współbieżnej pracy i mniejsza kontrola nad długimi zależnościami agentów niż Beads.

## Konsekwencje

- Pozytywne: zadania są dostępne lokalnie, gotowa praca wynika z zależności, a odkrycia można wiązać przez `discovered-from`.
- Negatywne: osoby nietechniczne potrzebują CLI albo osobnego read-only eksportu.
- Migracja/kompatybilność: `.beads/metadata.json`, `.beads/config.yaml` i instrukcje Codex są wersjonowane; lokalna baza Dolt pozostaje ignorowana.
- Weryfikacja: `bd version`, `bd info`, `bd setup codex --check`, `bd hooks list`, eksport/backup i test świeżego klonu.

## Rollback lub zastąpienie

Przed zmianą wykonaj `bd export --all` oraz `bd backup`. Następnie uruchom
`bd setup codex --remove`, usuń hooki Beads i zachowaj eksport JSONL jako dane
przejściowe. Migracja do innego trackera mapuje epiki, statusy, zależności,
komentarze i identyfikatory z pliku eksportu.

## Dokumenty i implementacja

- Źródło prawdy do aktualizacji: `AGENTS.md`, `agents/README.md`, `agents/09_agent_playbook.md`
- Powiązane zadania: epiki E0–E6 w Beads
- Zastępuje/zastąpiony przez: `nie dotyczy`
