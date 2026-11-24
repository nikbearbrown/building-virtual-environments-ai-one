# Chapter 3 — Design movement and collision

*What you see, what stops you, and what receives your action are three separate objects.*

Imagine facing an open-looking gap. In one direction you pass; in the other your avatar hits something invisible. If a directional gate is intentional, it needs a readable rule and a reliable way out. If the obstacle and cue disagree because somebody changed a mesh but not its collider, it is a defect. Looking at the same footage cannot tell you which mechanism was responsible.

After this chapter, trace an input to movement, state the collision layers, and test a directional passage on both approaches and during an interrupted crossing. The rules here are driven by the visitor's input and geometry, not a simulated opponent or agent planner.

## Start with a speed you can measure

Two input axes name desired lateral and forward motion. Limit a diagonal vector's length to one; otherwise combining two full axis components yields length $\sqrt2$ and a diagonal becomes faster. The visitor in the lab moves horizontally at a target speed of 3 world units per second when needed. At 60 physics ticks per second, an unobstructed step covers 0.05 units along a full-strength cardinal axis. The engine's `move_and_slide()` interprets the assigned velocity in units per second and takes the simulation step. Do not multiply that velocity by the physics delta a second time. With no jump or ground simulation in the lab, $y$ stays fixed at the visitor's starting center height; adding ramps or gravity is a new contract. A wall changes *actual displacement*, so do not equate desired velocity to completed motion.

The avatar has a visible capsule and a capsule-shaped collider. The collider is what the physics system treats as solid. Its radius 0.30 units and the wall half-thickness 0.08 explain why the center should stop outside about 0.38 units from the divider plane when a barrier is present, before contact tolerances. A center reported 0.38 from the plane is not “floating clear by 0.38.” The visitor extends from its center. To check an actual collision, compare position and a recorded collision contact; a mere failure to move might have been an empty input.

| Role | Layer bit value | Relevant mask in this lab |
| --- | ---: | --- |
| World walls and pedestal | 1 | Visitor, 2 |
| Visitor | 2 | Walls or gate, 1 OR 8 = 9 |
| Kiosk sensor | 4 | Visitor, 2 |
| Center gate | 8 | Visitor, 2 |

A layer is the membership label, a mask lists categories a participant observes for its purpose. A collider stopping a body and an overlap sensor notifying logic are different operations. The [Godot Area3D reference](https://docs.godotengine.org/en/stable/classes/class_area3d.html) documents the layer-to-mask requirement for overlaps. The kiosk sensor has volume and can emit an entry event, but it does not hold the visitor on a floor tile. In the supplied lab the visitor responds to walls/gate; the sensor observes the visitor's layer. If layout code moves the visible pad, verify the sensor center separately. If someone changes a mask to zero, a geometric overlap still exists in the diagram but no monitored entry event is delivered. Both errors are possible even though the scene looks good.

## Earn a directional exception instead of disabling a wall

The divider lies at world $z=0$. Negative $z$ is north. From a south approach near the middle gate, a negative $z$ movement direction grants this visitor an exception to this particular gate collider. It does not grant an exception to the whole divider, all obstacles or all visitors. Once the capsule clears to the north the exception is removed. While the visitor is straddling the slab, retain the exception so reversing before commitment cannot trap the capsule inside a just-reinstated collider. Returning far enough south also removes the exception. The exercise uses 0.44 units as a clearing threshold, slightly larger than radius plus barrier half-thickness, and allows the south approach before contact at 0.65 units. Neither number is a universal physics setting: a new avatar size or much faster step must change or retest the entry and clearance conditions.

The route to the right has ordinary geometry with no directional gate. A southward return should work there. Running the approach tests only at the middle gives a plausible false fix: reject all southward movement through the divider and declare the one-way passage correct. Test the east lane as an independent behavioral case. Running only open-space steps can also miss a smaller or misplaced wall. The included engine harness checks a collision along the divider away from both passages. To probe error recovery separately, begin a permitted entry and reverse in the slab, then verify both movement and removal of the exception.

The supplied script constrains the problem deliberately: one controlled character, no spawn inside the slab, fixed 60 Hz simulation, no portal speed boost, no network delay. A start overlapping the barrier, a class of faster actors, streaming physics updates or a moving gate would require another design and tests. Do not describe the test fixture as a general one-way-collision algorithm. For other character movement forms see the engine's [CharacterBody3D reference](https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html). On a different engine, keep the behavior test and reconsider how the engine computes contacts and update order.

## Exercises

- **Warm-up, steps:** Calculate the expected free cardinal distance after 12 physics ticks. Explain why a blocked approach is not a speed calibration.
- **Warm-up, layers:** Say which row needs to change for the kiosk to ignore the visitor while player movement remains identical.
- **Application, mismatch:** Predict a trace with the correct sensor shape and a wrong mask, then with the correct mask and a visibly displaced floor mark.
- **Application, sequence:** Trace the central passage south-to-north, north-to-south, and a reverse before the capsule clears. Include the exception state.
- **Synthesis, recovery:** Specify a return route that remains possible even if the directional passage cannot be used southbound. Verify a center and an off-center approach.
- **Challenge, scaling:** Increase the visitor radius in a copy. Name each geometric assumption and the test you need before approving the change.

You can now ask why an approach failed instead of treating every blocked path as a bad texture. In Chapter 4 an on-screen cue depends on what happened before, even when its location is right.

[Back to the contents](../README.md)
