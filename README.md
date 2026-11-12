# hope_playground

The test game for trying out hope's features (formerly DungeonTracks, a piggi port of the C#
DungeonTracks). Its own git repository next to `../hope` and `../piggi` in `~/Projects`;
`versions.txt` holds the hope and piggi commits it was last committed or published with (hope's
README, "Versions"). Open `hope_playground.code-workspace` in VS Code: the game and hope, each
committed on its own.

The scenes (each file's header lists its keys):

- F1 the level scene (`level_scene.pg`): the level `test` (`assets/levels/test.level`) as a game
  shows it (the fixed canvas, the arrow keys move the view); F1 again: the level editor (the free
  canvas, every shown layer, the tile grid, the layer panel with show/hide; the middle mouse button
  pans, the wheel zooms; click a layer to edit it: B brush, R rectangle, I pick (or Alt+click),
  left paints, right erases (the other button cancels a rectangle), the palette of its tileset; autotile layers: solid and open; Ctrl+S
  saves the file; Ctrl+Z / Ctrl+Y undo and redo a stroke, a rectangle, showing or hiding a layer;
  the view, the mode, the selection and the undo steps are kept in `build/editor/` between runs and
  across F5, unsaved steps come back to redo)
- F3 the start scene (`main.pg`): Sorcy runs in circles, Susi (a 3D sprite on tracks) drives with
  WASD, the arrow keys or a gamepad; camera shakes, following, translucent sorting
- F2 the physics scene (`physics_scene.pg`): hope's collision world, shots, rams, impulses
- F10 the tilemap demo (`editor.pg`): ground layers, autotile walls, a decal map
- F4 the navigation scene (`navigation_scene.pg`): agents of three sizes and four profiles
- F6 the audio scene (`audio_scene.pg`): music layers on the beat grid and the spatial audio test
- F7 the lighting scene (`lighting_scene.pg`, the fixed 320 x 180 canvas): lights and shadows in
  DungeonTracks' mood (its ambient and torch measured in the game jam's Let's Play)
- F8 the UI scene (`ui_scene.pg`, the fixed canvas): a title screen, options (volumes,
  fullscreen; saved with hope's Storage (the value `settings` in `storage.json`) when the options screen is left: `build/user/` in the internal mode,
  localStorage on the web), the controls (hope's `Ui.Controls`: click a binding, press the new
  key or button; saved as the value `bindings` at once, Reset brings the game's back) and the scrolling credits with hope's UI (`hope/ui.pg`), on test sprites in
  `assets/ui/` (made by a script: rounded boxes with attach0/attach1 for the 9-slices); the
  mouse, the keys and a gamepad
- `save_samples/`: storage.json files of earlier versions; in the internal mode they must still
  read as their `.expected.json` say (hope's `SaveSamples.Check`, in `main.pg` for `settings`;
  hope checks `bindings`). Copy `build/user/storage.json` there when the save format matters.

The camera pans with the middle mouse button and zooms with the wheel. Escape quits (in the UI
scene it goes back), F11 toggles fullscreen.

```
piggi run .                    # desktop: build/desktop/hope_playground
piggi run . --target=internal  # hot reloading (build again while it runs)
piggi run . --target=web       # the browser: http://localhost:8000/
../hope/tools/publish.sh .           # release builds in publish/<target>/
```

The project file is `{ "references": ["../hope"], "kind": "game" }`: hope defines the targets.

The internal target runs in the internal mode: it bakes `assets/` into `build/graphics.dat` with
Bakie (part of hope's host), rebakes every second while it runs and reloads
the pack when it changes, and loads the game code again when it is rebuilt. F5 restarts the game.

`assets/fonts/` holds the BDF fonts and the packs Fontuna bakes from them (hope's README).
