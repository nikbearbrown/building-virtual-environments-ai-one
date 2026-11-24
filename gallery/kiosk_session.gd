extends RefCounted
## Local session model. It does not inspect keyboard, paths or game AI.

enum Stage { READY, DETAIL, COMPLETE }

var stage: Stage = Stage.READY
var inside := false


func enter() -> void:
	inside = true


func leave() -> void:
	inside = false


func press() -> bool:
	if not inside or stage == Stage.COMPLETE:
		return false
	if stage == Stage.READY:
		stage = Stage.DETAIL
	else:
		stage = Stage.COMPLETE
	return true


func cue() -> String:
	if not inside:
		return "Approach the kiosk in the northwest."
	match stage:
		Stage.READY:
			return "Kiosk ready. Space: Read the exhibit."
		Stage.DETAIL:
			return "Exhibit: a readable route has two cues. Space: Finish."
		_:
			return "Exhibit read. Use the east return lane."
