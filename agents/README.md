# Biblia produkcyjna IdleNecro

Ten katalog jest operacyjnym źródłem prawdy dla ludzi i agentów pracujących nad `IdleNecro`. Dokumenty są po polsku, natomiast nazwy plików, typów, identyfikatorów i kod pozostają po angielsku.

## Szybki start

Przed każdym zadaniem:

1. Przeczytaj [wizję produktu](00_product_vision.md).
2. Dobierz dokumenty domenowe z tabeli poniżej.
3. Sprawdź aktualny projekt i edytor zgodnie z [workflow Godot MCP](06_godot_mcp_workflow.md).
4. Zapisz kryteria akceptacji w [specyfikacji funkcji](templates/feature_spec.md) albo brief assetu w [szablonie assetu](templates/asset_brief.md).
5. Zrealizuj najmniejszy kompletny wycinek, przetestuj go według [Definition of Done](08_qa_definition_of_done.md) i zaktualizuj dokumentację.

## Mapa dokumentów

| Dokument | Jest źródłem prawdy dla |
| --- | --- |
| [00_product_vision.md](00_product_vision.md) | odbiorcy, filarów produktu, platform i granic v1 |
| [01_game_design.md](01_game_design.md) | pętli gry, szkół, progresji, runu i ekonomii |
| [02_art_bible.md](02_art_bible.md) | stylu, izometrii, animacji, UI, VFX i audio |
| [03_asset_pipeline.md](03_asset_pipeline.md) | generowania, obróbki, importu i pochodzenia assetów |
| [04_technical_architecture.md](04_technical_architecture.md) | warstw technicznych, danych, zapisu i symulacji |
| [05_coding_standard.md](05_coding_standard.md) | GDScript, scen, zależności i obsługi błędów |
| [06_godot_mcp_workflow.md](06_godot_mcp_workflow.md) | bezpiecznej pracy z edytorem, runtime i logami |
| [07_ui_mobile_accessibility.md](07_ui_mobile_accessibility.md) | responsywnego UI, dotyku i dostępności |
| [08_qa_definition_of_done.md](08_qa_definition_of_done.md) | testów, macierzy urządzeń i akceptacji |
| [09_agent_playbook.md](09_agent_playbook.md) | przebiegu zadania i raportu końcowego |

Szablony znajdują się w [`templates/`](templates/): specyfikacja funkcji, brief assetu, rekord decyzji i prompt obrazu.

## Hierarchia źródeł prawdy

- Wymaganie użytkownika może świadomie zmienić kanon. Zapisz taką zmianę w dokumencie domenowym.
- Dokument domenowy określa intencję; kod i assety mają ją realizować, a nie zastępować.
- Rekord decyzji wyjaśnia odstępstwo. Nie może po cichu nadpisać wizji produktu.
- Wartości balansowe należą do danych gry. Dokumentacja opisuje ich znaczenie, zakres i wartość startową tylko wtedy, gdy jest ona kanoniczna.
- Jeśli implementacja przeczy dokumentacji, zatrzymaj rozszerzanie rozbieżności: ustal, która strona jest błędna, popraw ją i odnotuj wynik.

## Słownik

| Termin | Znaczenie |
| --- | --- |
| run / wyprawa | pojedynczy rozdział trwający docelowo 15–25 minut |
| szkoła | grywalny archetyp nekromancji wybierany przed runem |
| build | szkoła, wyposażenie, zdolności i ulepszenia wybrane w runie |
| boon / dar | jedno z tymczasowych ulepszeń resetowanych po runie |
| meta | trwałe odblokowania i rozwój pomiędzy runami |
| hub / Czarny Relikwiarz | bezpieczna scena zarządzania meta-progresją |
| encounter | jedno starcie lub zdarzenie na mapie rozdziału |
| style anchor | zatwierdzony obraz referencyjny projektu, nie cudzy asset |
| logical pixel | jednostka layoutu UI niezależna od fizycznej rozdzielczości ekranu |

## Zasady utrzymania

- Linkuj zamiast kopiować całe reguły do wielu dokumentów.
- Każda decyzja ma jednego właściciela domenowego i jedno miejsce aktualizacji.
- Placeholder w szablonie nie jest decyzją. W aktywnej specyfikacji wszystkie pola wymagane muszą być wypełnione albo jawnie oznaczone jako „nie dotyczy” z uzasadnieniem.
- Linki wewnętrzne, nazwy identyfikatorów i wartości kanoniczne sprawdzaj przy każdej zmianie dokumentacji.
