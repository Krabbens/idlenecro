# Image prompt: `<asset_id>`

Ten szablon jest rusztowaniem promptu, nie listą obowiązkowych argumentów narzędzia. Usuń niepotrzebne linie. Nie dopisuj fabuły, obiektów ani marek, których nie wymaga brief.

```text
Use case: stylized-concept
Asset type: <game character concept | enemy concept | environment concept | UI icon | tileable texture | portrait>
Primary request: <główne, konkretne żądanie>
Input images: <Image 1: style reference; Image 2: edit target; ...> (optional)
Scene/backdrop: <otoczenie albo transparent background>
Subject: <główny temat, sylwetka i funkcja w grze>
Style/medium: original dark isometric low-resolution painted fantasy game art
Composition/framing: <2:1 isometric view; direction; crop; safe padding>
Lighting/mood: restrained light from upper-left; <nastrój>
Color palette: charcoal, cold stone, bone, oxidized metal; <school accent>
Materials/textures: <konkretne powierzchnie>
Text (verbatim): "<tylko jeśli tekst jest naprawdę wymagany>"
Constraints: original design; correct game scale; clear silhouette at target size; <invariants>
Avoid: logos; trademarks; watermarks; readable text unless specified; copyrighted characters; recognizable UI or symbols from existing games; extra limbs; inconsistent lighting; photorealistic noise
```

## Dla edycji

Zmień `Use case` na właściwy typ, np. `identity-preserve`, `precise-object-edit`, `background-extraction` albo `style-transfer`. W każdej iteracji powtórz niezmienniki:

```text
Primary request: change only <target change>
Constraints: preserve silhouette, proportions, equipment, pose, pivot, palette, lighting direction and all unmentioned elements; no extra elements
```

## Przykład: koncept przeciwnika

```text
Use case: stylized-concept
Asset type: enemy character concept for an isometric auto-battler
Primary request: an original ash-buried grave sentinel that protects narrow crypt passages
Scene/backdrop: genuinely transparent background, no environment
Subject: squat two-tile guardian made from cracked funerary ceramic, old iron bindings and compact bone fragments; broad readable base; no weapon
Style/medium: original dark isometric low-resolution painted fantasy game art, designed for later sprite production
Composition/framing: full body, 2:1 isometric view facing southeast, centered, generous transparent padding, feet and ground contact fully visible
Lighting/mood: restrained cold key light from upper-left, short contact shadow, solemn and heavy
Color palette: charcoal, cold gray stone, muted bone, one small burnt-orange ember accent
Materials/textures: matte cracked ceramic, oxidized iron, dry ash, worn bone
Constraints: original design; clear silhouette at 128-pixel display height; consistent game scale; actual alpha; no text
Avoid: logos; trademarks; watermarks; copyrighted characters; recognizable symbols from existing games; extra limbs; floating feet; photorealistic noise; glossy armor; neon glow
```

## Przykład: ikona reliktu

```text
Use case: stylized-concept
Asset type: game UI relic icon
Primary request: an original reliquary needle that links two summoned creatures
Scene/backdrop: genuinely transparent background, no scene
Subject: one hooked bone needle threaded with a short muted teal soul filament
Style/medium: low-resolution painted game icon, strong silhouette, restrained detail
Composition/framing: centered diagonal object, generous padding, square canvas, readable at 64x64 pixels
Lighting/mood: upper-left highlight, compact contact shading
Color palette: aged bone, dark iron, one muted teal accent
Constraints: original design; no text; actual alpha; single object only; clean edges
Avoid: logos; trademarks; watermarks; runes; pentagrams; ornate background; extra objects; neon glow
```

## Checklista przed wywołaniem

- [ ] Brief podaje przeznaczenie, rozmiar, pivot i kryteria.
- [ ] Każdy obraz wejściowy ma przypisaną rolę.
- [ ] Prompt nie zawiera nazwy cudzej gry, marki ani artysty.
- [ ] `Constraints` wymienia wszystkie niezmienniki.
- [ ] `Avoid` obejmuje znaki wodne, tekst i typowe artefakty.
- [ ] Wiadomo, czy wynik jest preview, czy ma trafić do workspace.
- [ ] Po generacji wynik zostanie obejrzany i zmieniany pojedynczą iteracją.
