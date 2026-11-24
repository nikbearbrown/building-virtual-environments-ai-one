# Building Virtual Environments (AI Plus One)

**Compact first draft.** Five original chapters and an inspectable 3D gallery. This is not a finished textbook, an institution's course, or a replacement for an existing course companion. You should be able to follow a short program and move files; no previous real-time 3D work is assumed.

The design problem is a reading gallery someone can enter, understand and leave. Build the same evidence twice: once as a spatial explanation, then as a run that someone else can check. Each chapter starts from ideas that carry across engines. The optional project uses Godot 4 and generated primitive shapes; it imports no external meshes, textures, plugins or agent dependencies.

## Learning outcomes

After working through this draft, readers should be able to:

- Organize a scene and use layout, transforms, and visual cues to make it readable.
- Design motion, collision, and interaction rules that can be tested in the engine.
- Use an observed run, visual checks, and measurements to explain what a scene does and what still needs playtesting.

## Chapters

1. [Make a scene you can reason about](chapters/01-scene.md)
2. [Build a readable environment](chapters/02-readability.md)
3. [Design movement and collision](chapters/03-motion.md)
4. [Connect actions to state](chapters/04-interaction.md)
5. [Evaluate before handing off](chapters/05-validation.md)
6. [Independent transfer capstone and evidence sheet](practice/capstone.md)

## Run the optional lab

From the book root, use a Godot 4 binary named `godot` or substitute your local executable's full path:

```sh
godot --path gallery
godot --headless --path gallery --script res://checks/check_scene.gd
godot --path gallery --resolution 900x650 --disable-vsync --script res://checks/profile_scene.gd
```

Alternatively import [the project file](gallery/project.godot) in the Godot project manager and run its main scene. Move with the arrow keys or WASD; use Space in the kiosk zone and F to show/hide the crowded visual branch. Both passages cross the central divider; use the center opening northbound and the bar-marked east opening to return. The east path is a two-way physical opening, not a second actuator. Start position and camera stay fixed for the optional stationary comparison. The program exits automatically after that comparison.

The keyboard route, site map and unaided tracing activity do not require a model. The executable checks use actual engine transforms, collision and overlap events; they do not establish input-device accessibility or replace independent play. Tested with Godot 4.7.2 on macOS; see the [verification record](practice/verification.md) for measured scope. No Windows, Linux, headset, console or platform export was tested. Do not commit generated `.godot/` cache files, video captures, exports, or private review notes.

A full edition would deepen platform adaptation, import workflows, rendering and accessibility; this one stays at spatial composition, interaction and validation. It does not teach autonomous characters, game-AI planning, or a Walker, Figma, Blender or engine-specific toolchain in depth.
