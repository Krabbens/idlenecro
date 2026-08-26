# IdleNecro — instrukcje dla agentów

Zakres tego pliku obejmuje całe repozytorium.

Przed rozpoczęciem pracy przeczytaj [mapę dokumentacji](agents/README.md), a następnie dokumenty wskazane dla danego rodzaju zadania. Dokumentacja w `agents/` jest źródłem prawdy dla produktu, grafiki, architektury, jakości i sposobu pracy.

Zasady obowiązkowe:

1. Zachowuj oryginalną tożsamość `IdleNecro`. Nie kopiuj assetów, nazw, UI, ikonografii, run ani charakterystycznych projektów z Diablo, OpenDiablo2 lub innych gier.
2. Projektuj dla Godot 4.7.x, PC i urządzeń mobilnych w orientacji poziomej. Kod zapisuj w statycznie typowanym GDScript.
3. Przed zmianą projektu sprawdź stan przez `gdmcp`; po zmianie uruchom właściwe testy, sprawdź logi i wykonaj wizualne QA, jeśli wynik jest widoczny.
4. Nie dodawaj globalnego stanu, zależności, autoloadu ani nowego formatu danych bez uzasadnienia w architekturze.
5. Każda funkcja ma mieć kryteria akceptacji. Każdy asset ma mieć brief, źródło, prompt lub informację o pochodzeniu oraz potwierdzone prawa użycia.
6. Nie pozostawiaj nieprzypisanych `TBD`, cichych fallbacków ani znanych błędów bez wpisu w raporcie końcowym.
7. Jeżeli decyzja zmienia kanon albo publiczny kontrakt danych, utwórz rekord według `agents/templates/decision_record.md` i zaktualizuj właściwy dokument źródłowy.

Kolejność rozstrzygania konfliktów: bieżące wymaganie użytkownika → ten plik → dokument domenowy w `agents/` → zatwierdzony rekord decyzji o późniejszej dacie → istniejąca implementacja.
