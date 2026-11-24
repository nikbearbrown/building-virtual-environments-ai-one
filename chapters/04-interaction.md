# Chapter 4 — Connect actions to state

*The same key can mean read, finish or nothing. Its meaning belongs to a state, not to a keyboard.*

Imagine a visitor walks into an information zone, opens its first page, backs away to make room, then returns. The kiosk could start over, resume, complete itself, or do nothing. Any of those behaviors can be implemented. Their difference is what you promised the visitor, and whether input, ownership and visible feedback agree with the promise.

After this chapter, separate proximity from progress, write a small transition table, and exercise the same input through interruption, re-entry and repeat. The kiosk has no autonomous goal selection. It is a local interface with a transparent rule.

## State says what survives the next event

The [kiosk session source](../gallery/kiosk_session.gd) stores two distinct pieces of information: whether the monitored visitor is inside its zone, and which page stage has been reached. The inside flag controls whether an action is accepted. Stage controls what that action means. Leaving the zone does not erase stage. Entering the zone does not change stage either. That separation makes it possible to hide a prompt outside the zone without treating movement as a reading action.

| Situation | Event | Resulting page stage | Cue or effect |
| --- | --- | --- | --- |
| Outside, any stage | Space | Unchanged | No action accepted |
| Entering, Ready | Enter event | Ready | Show read prompt |
| Inside, Ready | New press | Detail | Present short exhibit and finish instruction |
| Inside, Detail | Exit event | Detail | Hide detail and show approach instruction |
| Outside, Detail | Enter event | Detail | Show the same detail again |
| Inside, Detail | New press | Complete | Show completion and east return |
| Inside, Complete | New press | Complete | No duplicate completion |
| Any | Keyboard echo event in input handler | Unchanged | Ignore repeat |

This is a finite transition table over local interaction state. “Action allowed” is not stored as a third unrelated mutable flag. It follows from presence and the current stage. If the display says “Read” in the completed state, that is a feedback defect even when the state transition code itself is correct. If the engine emits a zone signal from an unrelated rigid object, a well-scoped receiver checks which body entered. Passing wrong events to correct logic is still wrong.

Who owns the state? One kiosk instance does. Player movement knows proximity and collisions but does not increment local content. The kiosk does not know any global quest flags. In a real shared experience you might store separate progress per visitor or synchronize a session, but then need identity, authority, reconnect rules and a new test. Here reloading the project loses the session by design. Do not use “persistent” without naming the lifetime.

## Check the timing at the boundaries

Walk the state on paper: enter, press, leave, press outside, re-enter, press, press. Write the cue and stage after each event. In the lab the expected stages are Ready, Detail, Detail, Detail, Detail, Complete, Complete. Notice what the outside press and final repeat prove: a place-independent global shortcut or unguarded next-stage function could appear to work on the happy path. It would fail these two checks.

An actual engine scene is also a timing system. This gallery gets entry/exit signals from a monitored Area3D and sends an action when Godot reports a new Space key press. Keyboard echo is explicitly ignored. The headless harness checks the actual area by moving its test actor into the zone and allowing several physics ticks; it checks the echo handler with a synthetic echo event and calls the same public action for the transition sequence. That is specific evidence, not a claim to have captured every physical keyboard layout, OS key repeat setting, or same-tick boundary. An input just as the visitor crosses the zone depends on ordering of events. If repeated human tests find an edge ambiguity, specify whether the authoritative simulation snapshot is the most recent overlap event or an explicit queued intent evaluated after the relevant tick. Write and run the edge case rather than adding a convenient delay and hoping.

A signal can be received twice; an Action callback can be connected twice; a user can tap quickly. These are different failure mechanisms. Here two intentional presses are meaningful, while a held key's repeat is not. Turning everything into a debounced one-second command could improve one test and make the second intentional press feel broken. Design for meaningful edges before designing to hide repetitions. On gamepad and alternate input devices, bind the same intended action, then verify the same state table and focus handling. Those devices are not supported or tested by this minimal lab.

## Feedback should be an observable output

A short instruction panel can reveal which rule is active. Readable feedback need not be louder or larger each time; it needs to say what happened and whether there is a next action. The visitor sees either “approach,” “read,” the detail and finish key, or “exhibit read.” The entrance and exit are still spatial cues. If audio is later added, preserve the textual and visual confirmation so silence does not block the loop. A button press animation might show the key was heard, but if a visual animation is allowed to drive completion directly then playback interruption becomes a logical event. Keep evidence about cue onset separate from evidence about stage ownership.

An optional assistant can help with one check, not announce the scene works. Give it your own transition table and the first failing sequence. Ask for one prediction that would distinguish an event-wiring bug from a state update bug. Then rerun the sequence and check the outputs independently. Restrict the helper to this fixture and do not give it an assessment answer key or a real player's logs. A patch that simply removes re-entry, hides the test or fakes the prompt does not meet the scope.

## Exercises

- **Warm-up, trace:** Fill in stage and cue for enter, press, exit, outside press, return, press, press.
- **Warm-up, ownership:** State what is reset when the visitor leaves and what resets only when the entire scene is restarted.
- **Application, failed input:** Modify a disposable copy to ignore only the exit event; predict which evidence detects it.
- **Application, timing:** Devise a check plan for leaving the zone and pressing within one physics tick; name the required acceptance rule before running it.
- **Synthesis, feedback:** Add a proposed non-audio completion cue and say how you would detect a cue/state contradiction after re-entry.
- **Challenge, independence:** Specify two kiosks sharing the same art; arrange a sequence that exposes if your code mistakenly shares session progress.

You can now defend the mechanism behind a visible prompt. The last chapter asks which parts of that defense are sufficient to hand work to another person.

[Back to the contents](../README.md)
