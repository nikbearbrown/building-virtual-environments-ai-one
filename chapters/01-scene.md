# Chapter 1 — Make a scene you can reason about

*The origin is an agreement. If two people choose different origins, the numbers stop talking to each other.*

Imagine you build a sign for a doorway in a small museum. It looks perfect in the modeler's preview. In the assembled gallery it floats in the wrong corridor. Someone suggests translating it until it looks right in one camera. That may fix one frame without fixing the scene. The sign has two identities: a point relative to its own parent, and a point relative to the whole world. Make both testable before moving another object.

After this chapter, draw a scene hierarchy, compute one composed position, state how scale enters it, and design a small, visible import test. You need only signed axes and the idea of a rotation.

## Begin with the routes, not the assets

The fictional Reading Room Relay gallery admits a visitor from the south, sends them to a northwest kiosk and offers an east lane back. The [plan](../figures/floor-plan.svg) is an annotated top view, not a claim about screen pixels. On the plan, right is increasing world $x$, and down is increasing world $z$; the northward arrow points toward decreasing $z$. World $y$ is vertical. For this example read one world unit as one meter. The floor is ten by ten, with a surface at $y=0$. This convention is a contract between the scene, its tests and the person creating a replacement asset.

One scene node may be a spatial parent, one a visible mesh, one a collider, one an interaction target. Those roles frequently share a location but are not interchangeable. The original lab uses a parent called ExhibitFrame; its child LocalSign locates a sign. The independent visitor and gate do not inherit the exhibit frame. If your hierarchy makes the visitor a child of a moving door, moving the door can also move the character. The graph is not merely a folder tree. It describes whose coordinate frame changes when a parent changes.

A reusable scene is a definition. Two instances can share a mesh or material while keeping distinct transforms and interaction state. To make that concrete, duplicate a display frame and put the copy on the other side of the room. Reuse the visual geometry; keep labels and state local to the instances. Editing a shared material resource can visibly affect both displays, which is useful when you want consistency and confusing when you expected one edit to remain local. Separate resource ownership from node ownership before asking an assistant to make an art change. The engine-independent lesson is about instance state and asset sharing, not where an editor places its Duplicate command.

## Measure one point all the way through

An affine transform combines a linear part (rotation, scale, and potentially shear) and a translation. To transform a point from local parent coordinates into world space, apply the parent's basis to the local coordinates and then add the parent's translated origin. Matrix multiplication is not a commutative shuffle: a different transform order can result in moving around a different pivot. A direction vector should not receive the positional offset.

The exhibit parent sits at $(2,0,-1)$ and turns +90 degrees about world up. In this setup, positive local $x$ becomes negative world $z$, and positive local $z$ becomes positive world $x$. You can check this with a drawn horizontal axis instead of memorizing a sign. The child's local position is $(1,1.8,0.2)$. Rotation maps it to $(0.2,1.8,-1)$ before translation, so the world position is:

$$ (2,0,-1)+(0.2,1.8,-1)=(2.2,1.8,-2). $$

The [engine check](../gallery/checks/check_scene.gd) looks up the world anchor and compares it within 0.001 units. The sign uses a billboard in the supplied scene so it faces the camera while preserving the point. Do not use its view-facing text to infer the exhibit's actual rotation. A marker at the child origin tests placement; two marker points along separate axes can also test orientation. If a tool prints the scene origin correctly but emits a sign at local coordinates interpreted as world coordinates, that test of the child, not the nice picture, detects it.

Now suppose the parent is scaled by 2 before rotation. The child’s local offset doubles, including height: $(2,3.6,0.4)$ becomes $(0.4,3.6,-2)$ and then $(2.4,3.6,-3)$. The parent translation did not double. A common scale bug is to rescale the already-translated world point, which moves it relative to the world origin. Another is to stretch a visible mesh while forgetting the corresponding collision shape. If you need one axis scaled differently, test the geometry that moves and the collider shape on all relevant axes; not every physics shape behaves well under arbitrary nonuniform scaling. The [official transform guide](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html) shows Godot's local and global properties. Use the same two marker test when you switch engines rather than assuming their naming or forward-axis conventions match.

## An import test with reasons to fail

Before importing a decorative mesh, put a known one-unit cube at the target pivot and register its bottom to the floor. Mark positive local $x$ and forward with two dissimilar shapes. When a file imported from a modeling tool arrives sideways, compare the forward marker and pivot separately. Correct the orientation and unit conversion at the intended import boundary. Avoid scattered per-instance compensations that conceal how the authored coordinate system maps to the scene. Keep a small test scene placing a second instance near an existing collider to catch extra scaling. Never assume you may redistribute a source model or texture simply because your editor could open it; bind each new asset to an explicit original or permitted source before handoff.

One useful comparison for a collaborator is a before/after with two coordinate probes, a dimension measurement and a statement about what has not moved. Be specific: “The sign pivot is within 0.001 units of the expected point, the rear wall kept $z=-5$, and the avatar extent did not change.” Nothing in those assertions says that the sign is readable or the room entertaining. Those checks belong to a different argument.

## Exercises

- **Warm-up, frame:** Label the direction of increasing $x$, $y$ and $z$ on a copy of the gallery plan; then draw where the chosen local +$x$ axis goes under the parent yaw.
- **Warm-up, composition:** Calculate the sign's world point if the parent is moved one unit east and its yaw is unchanged.
- **Application, import:** Design two marker probes and a geometry-width check for a mesh that is unexpectedly rotated and ten times too large.
- **Application, instances:** Describe how two wall signs can share a base mesh yet respond independently to separate kiosk sessions.
- **Synthesis, audit:** You see a rectangle in the expected place after switching cameras. Give a test that could still find a wrong local frame and one that checks a collider mismatch separately.
- **Challenge, portability:** Write what another engine must preserve to pass these spatial checks without sharing object names or axis labels.

You can now make location claims somebody else can inspect. In Chapter 2 those locations become cues, and a physically correct marker can still be too small or too late to help.

[Back to the contents](../README.md)
