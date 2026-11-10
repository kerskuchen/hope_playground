# hope_playground

The test game for trying out hope's features (formerly DungeonTracks, a piggi port of the C#
DungeonTracks). Its own git repository next to `../hope` and `../piggi` in `~/Projects`;
`versions.txt` holds the hope and piggi commits it was last committed or published with (hope's
README, "Versions"). Open `hope_playground.code-workspace` in VS Code: the game and hope, each
committed on its own.

The scenes (each file's header lists its keys):

- F1 the start scene (`main.pg`): Sorcy runs in circles, Susi (a 3D sprite on tracks) drives with
  WASD, the arrow keys or a gamepad; camera shakes, following, translucent sorting
- F2 the physics scene (`physics_scene.pg`): hope's collision world, shots, rams, impulses
- F3 the tilemap editor (`editor.pg`): ground layers, dual-grid walls, a decal map
- F4 the navigation scene (`navigation_scene.pg`): agents of three sizes and four profiles
- F6 the audio scene (`audio_scene.pg`): the music and the spatial audio test

The camera pans with the middle mouse button and zooms with the wheel. Escape quits, F11 toggles
fullscreen.

```
piggi run .                    # desktop: build/desktop/hope_playground
piggi run . --target=internal  # hot reloading (build again while it runs)
piggi run . --target=web       # the browser: http://localhost:8000/
../hope/publish.sh .           # release builds in publish/<target>/
```

The project file is `{ "references": ["../hope"], "kind": "game" }`: hope defines the targets.

The internal target runs in the internal mode: it bakes `assets/` into `build/graphics.dat` with
Bakie (part of hope's host), rebakes every second while it runs and reloads
the pack when it changes, and loads the game code again when it is rebuilt. F5 restarts the game.

`assets/fonts/` holds the BDF fonts and the packs Fontuna bakes from them (hope's README).
