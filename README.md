# hope_playground

The test game for trying out hope's features (formerly DungeonTracks, a piggi port of the C#
DungeonTracks). Its own git repository next to `../hope` and `../piggi` in `~/Projects`;
`versions.txt` holds the hope and piggi commits it was last committed or published with (hope's
README, "Versions"). Open `hope_playground.code-workspace` in VS Code: the game and hope, each
committed on its own.

Sorcy runs in circles, Susi (a 3D sprite on tracks) drives
with WASD, the arrow keys or a gamepad, the camera pans with the middle mouse button and zooms
with the wheel. Escape quits, F11 toggles fullscreen.

```
piggi run .                    # desktop: build/desktop/hope_playground
piggi run . --target=internal  # hot reloading (build again while it runs)
piggi run . --target=web       # the browser: http://localhost:8000/
../hope/publish.sh .           # release builds in publish/<target>/
```

The project file is `{ "references": ["../hope"], "kind": "game" }`: hope defines the targets.

The internal target runs in the internal mode: it bakes `assets/` into `build/graphics.dat` with
Bakie (part of hope's host), rebakes every second while it runs and reloads
the pack when it changes, and loads the game code again when it is rebuilt. F1 toggles the
tilemap editor (left mouse button sets tiles, right removes them), F5 restarts the game.

`assets/fonts/` holds the BDF fonts and the packs Fontuna bakes from them (hope's README). Like the C# version, the editor keeps the camera's 20°
rotation from the game, and the dual-grid display tiles are not computed yet (only the logic
tiles are drawn, as red squares).
