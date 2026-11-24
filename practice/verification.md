# Verification record: Reading Room Relay

This record applies to the original primitive-only teaching project shipped with this draft. It is not an engine benchmark for other scenes and is not human acceptance or accessibility certification.

## Tested behavior

- **Environment:** macOS, Godot `4.7.2.stable.official.ed1daf0bf`; graphics checks used OpenGL Compatibility, AMD Radeon Pro 5500M OpenGL Engine, and dummy audio. The headless checks used the dummy renderer and actual Godot scene and physics.
- **Headless evidence:** 20 of 20 checks passed, including the hand-computed rotated sign placement, directional passage and wrong-way contact, mid-slab retreat, ordinary wall block, sensor masks, repeat and re-entry behavior, and continuous movement from spawn to kiosk and from kiosk out the east opening. Movement was driven by harness input; some isolated cases use a harness-only teleport for setup. The repeat check injects a synthetic echo event into the handler rather than replaying an operating system keyboard.
- **Visual evidence:** Native captures taken at 900 × 650 and 720 × 520, including spawn, ready, detail and complete-with-decor. The initial capture, a 720 × 520 grayscale detail capture and a 900 × 650 completion capture were visually checked for framing, text and distinct markers. The floor plan was rasterized and checked separately. This verifies specific stills. It does not establish discovery or a route played by a person, focus behavior, a screen-reader bridge or alternate controller input. Diagnostic frames are not included in the source package. The scene uses no audio cues.

## Stationary windowed comparison

Same 900 × 650 viewport, same camera and starting visitor pose, synchronization disabled by the launch flag, 48 warmup frames and 120 sampled intervals per phase. The elapsed interval comes from the monotonic clock between process-frame signals. It is not GPU time. Numbers are rounded to two decimals; the draw-call column is a separate engine monitor.

| Phase | Northeast decor | Median interval (ms) | p95 interval (ms) | Maximum interval (ms) | Median draw calls |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | Hidden | 0.64 | 6.88 | 7.22 | 29 |
| 2 | Visible | 1.19 | 6.42 | 7.51 | 77 |
| 3 | Visible | 1.26 | 6.80 | 14.40 | 77 |
| 4 | Hidden | 0.60 | 6.86 | 6.96 | 29 |

This is one run, on one graphics stack. The visible group changed both monitored draw calls and median interval in this setup; the tail measures do not support a universal direction or target guarantee. It was not a fixed-fps capture and does not predict a moving walkthrough, update under load, or an exported player. No human playtest, platform export, Unity/Unreal execution, Windows/Linux verification, live course import or expert review is claimed.

[Back to the contents](../README.md)
