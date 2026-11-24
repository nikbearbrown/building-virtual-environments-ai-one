# Chapter 5 — Evaluate before handing off

*Passing the scene checker is a claim about a test; approval to hand a scene over is a broader claim.*

Suppose an assistant reports “scene complete, fast and accessible” after a command exits zero. A passing command can be useful. It cannot tell you whether a person recognizes the entrance, whether an exported build includes its resources, or whether a frame-time tail is acceptable on the intended machine. Break the single sentence into claims with different instruments. An untested claim can then stay open instead of borrowing credibility from a test aimed at something else.

By the end, design a route and defect check, compare one controlled frame-time contrast, distinguish behavior from export, and write what must be recovered if a patch corrupts the scene.

## Choose a route with evidence points

Start at spawn and move toward the center chevrons. Stop where the divider first matters, enter, attempt the wrong-way return at the same portal, then head to the northwest zone. Read the content, leave without finishing, return, finish, and use the east lane to leave. Record where the instruction was available, which inputs were used, what the camera hid, and whether you needed the schematic. For assistive or alternative input, explicitly list what device and configuration were used; this minimal version offers keyboard controls but no remapping screen, text scaling control, audio or screen-reader bridge.

| Claim | Instrument | One result that would fail the claim |
| --- | --- | --- |
| Scene point landed at its world coordinates | Probe global anchor versus hand calculation | Parent moves but marker stays in its previous world point |
| Portal permits intended passage, not any route | Run both approaches, reverse while straddling, take east exit | Center passes in both directions or east exit inherits the block |
| Prompt agrees with local progress | Trace inside and stage on exit/re-entry | Detail disappears permanently or completes on entry |
| Cue is discoverable without distinguishing hues | Inspect grayscale; observe a novice's first choice | Both markers look the same or key cue cannot be read before the choice |
| Renderer has useful headroom | Bounded, separately logged runs on the same route and build | Tail spikes exceed the budget under a repeatable scenario |
| Handoff opens elsewhere | Clean extraction and declared launch command | Missing linked scene, default-version mismatch, or outside assets silently loaded |

Save the actual sequence, version, setup, observed outcome, and one negative case. For visual tests, a screenshot can document geometry and legibility at one camera and size; a physical-keyboard walkthrough can check timing and control discoverability. Neither has the scope of a real user study. For physics, headless event/tick tests are fast and repeatable; they do not cover what the renderer draws. For accessibility, the useful next step can be to report a remaining limitation rather than tick a broad claim from a narrow proxy.

## Compare a load without changing the story

A nominal 60 Hz display gives about $1000/60=16.67$ ms per displayed refresh. A fixed 60 Hz physics simulation has its own tick schedule. Neither says every rendered frame takes that much work. Average frame rate can hide intermittent pauses. Record a frame-time distribution or wall-clock frame intervals and identify the measured quantity precisely. In this gallery the optional comparer takes elapsed intervals between process-frame signals on a live windowed renderer. The intervals can include waiting, engine work and scheduler effects. They are not direct GPU execution times. The draw-call monitor is separate and should not be used as a surrogate for elapsed time.

Press F manually to reveal 48 original decorative primitive meshes in the northeast branch; they do not add collision shapes. The controlled [comparer](../gallery/checks/profile_scene.gd) alternates hidden/visible/visible/hidden, holds the camera and visitor stationary, warms up each phase for 48 frames, and captures 120 intervals per phase. The script also prints the adapter and viewport, median, nearest-rank p95 and maximum. A nearest-rank p95 here is the 114th sorted interval of 120; six longer observations can still lie above it. The visual monitor and cumulative elapsed time answer different questions. For the checked Mac run, showing the branch increased the median draw-call count from 29 to 77 in both comparisons. The elapsed median increased too, but p95 moved in the opposite direction in that short stationary run and the maximum was highest in one visible phase. Do not force all metrics to tell one story. See the [checked measurement context](../practice/verification.md) and the official [Godot debugger and profiler guide](https://docs.godotengine.org/en/4.7/tutorials/scripting/debug/debugger_panel.html).

The stationary run isolates the cost of making one branch visible, not the performance of turning rapidly, entering the kiosk, first-time shader work, a larger room, an exported release build, or another graphics driver. Pin resolution, renderer, scene, synchronization setting and capture interval. Avoid fixed-fps movie recording for this measurement: render capture can affect timing or substitute a non-real-time schedule. In a later route check, run baseline and changed copies with the same warmup and steps in more than one order. If debugging, try an isolated draw change with the same visual result and verify it improves the constraint you actually care about. A high frame-limited median on one desktop is not platform capacity. Setting a threshold late based on the run does not establish that real users accept it.

## Hand over an audited, recoverable scene

Publish or share a clean source package appropriate for the destination, not your working cache. Include the engine version, peer launch command, asset origin notes, supported inputs, a short scenario and expected failure evidence. Validate path casing and packaged references. Never bundle a credential, proprietary font, imported unlicensed model or student work to make a local run appear complete. No platform export is part of this compact draft; source opening and engine validation are documented separately. When eventually making an export, rerun a cold-start routine through the exported executable, not merely the editor. A frame or file on your own computer does not prove a recipient has the same dependency.

Suppose the unaided route reveals the return sign hidden by new clutter. Ask an optional agent to move only the clutter group and add one predictable test stand point. Preserve spawn, collider geometry and controls. Ask for a description of touched files and the precise verification it can perform, not a universal success claim. Play the same region after the patch; compare screen legibility and gate behavior independently. Retain a known-good snapshot and name a recovery action such as reverting that single visual edit or restoring the mesh branch's hidden state. Do not restore by deleting originals or losing someone else's work. Reproducibility is part of the design, not stationery added after the work.

## Exercises

- **Warm-up, units:** Relate 60 Hz and 16.67 milliseconds, and distinguish wall-clock interval from GPU time.
- **Warm-up, boundaries:** Identify one thing the headless runner knows and one thing it cannot see.
- **Application, measurement:** Plan three measured route phases with one isolated branch toggle; list what you will hold constant and report.
- **Application, accessibility:** Propose a small view and a no-hue route trial. Record a distinguishable failure for each, not “looked fine.”
- **Synthesis, handoff:** Assemble a read-only package inventory with exact commands and a rollback step. Show one path link your check would catch if broken.
- **Challenge, reconcile:** Given a lower median and higher p95 after a change, make a defensible decision and propose one additional controlled run instead of averaging the disagreement away.

You can now turn handoff into a bounded claim about a particular version, not a promise that every possible route or machine was tried. Use the [transfer capstone](../practice/capstone.md) to show that the method travels to a new room.

[Back to the contents](../README.md)
