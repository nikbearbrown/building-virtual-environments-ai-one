# Chapter 2 — Build a readable environment

*If a visitor has to read your project files to find the doorway, the environment has not told them where to go.*

Suppose the center passage and east lane start as two otherwise identical gaps with two different paint colors. They look distinguishable in the editor. On a dim screen or in grayscale, the rule disappears. The fix is not necessarily a third, brighter color. The visitor needs independent clues to purpose, and they need those clues from the places where they actually make a choice.

After this chapter, lay out a blockout with decision points, distinguish between a material and readable evidence, and design a visual comparison that could fail without changing the route itself.

## First choose what the room is meant to say

In the [original gallery](../gallery/gallery.gd), a visitor spawns south of a divider. The expected loop is center entry → northwest kiosk → east return. Put an opening where that choice is made, before deciding what its decorative frame looks like. The entrance uses three narrow chevrons directed north plus the words ENTRY NORTH. The east lane has broad bars plus its own text. The kiosk uses a contrasting matte floor patch and a short literal label. The player is visibly a capsule, not another floor marker. The fixed camera includes the entire room; no rotation, pointer aim or audio is required for the demonstrated loop. Color supports the signs; it is not the sole difference between a north arrow and an east lane.

A blockout is useful because it is cheap enough to move a wall when evidence changes. Start with a single labeled shape for each functional surface, obstacle or action. Draw stand points before the entry and just after crossing. For each, ask what cue is on screen, what can occlude it, and whether a person can tell a blocked shortcut from the offered route. In this toy room the overhead camera removes a first-person visibility question: it will not reveal how a tall obstruction appears at eye level. If you later switch to a follow camera, repeat the route and resize tests. The camera choice is part of the evidence, not an implementation accident.

The east lane communicates return as a suggestion, not as a collision law. It is deliberately physically open both ways. The center portal is the only directional barrier. A signpost can suggest a route without constraining all movement, but copy that claims the east lane forbids northward movement would be false. The tests in the next chapter distinguish the two meanings.

## Materials and light are part of the communication

A mesh gives shape and orientation; a material describes how that shape appears under lighting and view. Base color is an ingredient, not a rendered pixel. Material roughness affects how focused reflections look; on a highly reflective sign a highlight can temporarily hide lettering. Ambient light raises areas not directly lit; a directional light models illumination from one direction at the scene scale. For the lab, primitive geometry and mostly matte materials make boundaries and labels easy to edit, and a colored panel behind the HUD stops the floor's changing brightness from determining text contrast. None of this is a lesson in making realistic wood. It is a lesson in isolating the thing you are asking the light to do.

Look at the scene in a size and position you will report. First locate the entry from the spawn; then locate the kiosk and return without referring to the schematic; then reduce the viewport or inspect a grayscale capture. Record where you stopped because the cue was hidden, small or ambiguous. A still shows one camera and resolution. It cannot prove that a moving visitor, a different monitor or a person with different perceptual abilities has a usable route. Text contrast guidance and a non-color redundancy check are useful design probes; they are not an accessibility certification for a game. The [W3C accessibility guidelines](https://www.w3.org/TR/WCAG22/) provide such principles for web content; a native 3D environment still needs its own interaction and assistive-device testing.

## Change three things, name the confound

Start with a deliberately weak paper version: identical shallow threshold bars, labels so small they blur at normal viewing, and plain dark materials. Change at most three independent parameters: the silhouette of the entry marker, the label's apparent image size, and the panel-to-text contrast. Keep camera, geometry and instructions fixed. You have a clear comparison only if the viewer sees the same choice point in each version. If you move the doorway while brightening its label, a faster route choice cannot be assigned to the label alone. If you make the arrow bigger but it now looks like a floor collision marker, the very change that makes it easier to see may make it harder to understand.

As a practical test, have a reader attempt either version with the task “enter, find the information, return” but no map explanation. Keep a record of first mistaken turn, whether they used the offered prompt and whether they could recover. One observer is useful evidence of one observed difficulty, not evidence about how everyone will perform. Without a second reader, write what you personally assessed and what judgment remains untested. The lab has no focus-management system or screen-reader bridge; do not report it as fully accessible because it is keyboard-operable.

## Exercises

- **Warm-up, affordance:** Point out an independent cue for the entry and for the east lane that does not rely on hue.
- **Warm-up, camera:** Sketch one view from which the top-down cue is visible but a first-person cue may be occluded.
- **Application, material:** Describe what a high-shine floor could do to the readability of markers. Change one material property and report from the same view.
- **Application, evidence:** Design a low-contrast failure without changing any collision or input settings. Write the exact first-choice observation you will check.
- **Synthesis, comparison:** At two viewport sizes, compare a stronger marker and label. State one confound and the observation that would disconfirm your recommendation.
- **Challenge, access:** Propose an alternative cue that improves a no-color, no-audio trial while leaving a useful test for people who cannot use the supplied keyboard mapping.

You can now describe what the scene tries to tell its visitor. Chapter 3 audits whether the geometry and input rules actually honor that message.

[Back to the contents](../README.md)
