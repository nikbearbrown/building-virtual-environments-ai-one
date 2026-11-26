# Building Virtual Environments (AI Plus One)

## About the book

This compact rough draft is for readers who can follow a short program and move files, but have not built a real-time 3D scene. Design a reading gallery someone can enter, understand and leave. You will make the space legible, connect movement and interactions to explicit rules, and show with checks what the build actually does. Godot 4 is optional for reading and needed for the runnable example.

## Start reading

Start with [Make a scene you can reason about](chapters/01-scene.md). Use the [complete chapter guide](#chapter-guide) to find every chapter in reading order. To run the example rather than read, open the [Godot gallery](gallery/README.md).

## Chapter guide

### Part 1 · Build a readable space

1. [Make a scene you can reason about](chapters/01-scene.md): Explain how a scene tree and transforms give a space stable structure.
2. [Build a readable environment](chapters/02-readability.md): Use landmarks and distinct routes to orient a reader.

### Part 2 · Make actions testable

3. [Design movement and collision](chapters/03-motion.md): Test a player route against collision geometry and camera movement.
4. [Connect actions to state](chapters/04-interaction.md): Connect user actions to session state and check the effect of reset.
5. [Evaluate before handing off](chapters/05-validation.md): Inspect a live scene and distinguish measured behavior from an untested claim.

## How to teach or study it

Read the floor plan before rebuilding a scene. Establish an understandable space, test movement and collision, then connect the kiosk to session state. In the [capstone](practice/capstone.md) move the reading station and check that routes and interactions survive. Use the [verification record](practice/verification.md) to distinguish Godot 4.7.2 checks on macOS from untested exports and human play.

## What’s in this repo

| Resource | Link | Coverage | Status |
| --- | --- | --- | --- |
| Manuscript | [README.md](chapters/README.md) | 5 written chapters | Compact rough draft |
| Exercises and assessment | [capstone.md](practice/capstone.md) | 1 independent capstone | Draft |
| Verification | [verification.md](practice/verification.md) | 1 engine verification record | Not human playtesting |
| Figures | [floor-plan.svg](figures/floor-plan.svg) | 1 floor-plan SVG | Included |
| Code and scene | [README.md](gallery/README.md) | 1 project, 1 scene, 2 behavior scripts and 2 check scripts | Godot 4 source, not an export |
| Blueprint or syllabus | — | — | Not found |
| Slides | — | — | Not found |
| Standalone quizzes | — | — | Not found |
| Separate answer-key file | — | — | Not found |
| Video files | — | — | Not found |
| Datasets | — | — | Not found |
| Web or packaged game export | — | — | Not found |

## Credits, license, and corrections

No license file was found; public access does not establish reuse rights. Report errors in the [repository issues](https://github.com/nikbearbrown/building-virtual-environments-ai-one/issues), with the chapter and a precise location.
