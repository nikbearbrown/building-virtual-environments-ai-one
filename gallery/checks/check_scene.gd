extends SceneTree
## Invoke from the gallery directory: godot --headless --path . --script res://checks/check_scene.gd

var scene
var failures := 0
var tests := 0


func _initialize() -> void:
	call_deferred("_run")


func _check(condition: bool, note: String) -> void:
	tests += 1
	if condition:
		print("PASS ", note)
	else:
		failures += 1
		push_error("FAIL " + note)


func _ticks(n: int) -> void:
	for i in range(n):
		await physics_frame


func _place(x: float, z: float) -> void:
	scene.test_input = Vector2.ZERO
	scene._set_gate_exception(false)
	scene.visitor.global_position = Vector3(x, 0.61, z)
	await _ticks(5)


func _run() -> void:
	scene = load("res://gallery.tscn").instantiate()
	root.add_child(scene)
	scene.use_test_input = true
	await _ticks(5)
	_check(scene.sign_anchor.global_position.distance_to(Vector3(2.2, 1.8, -2)) < 0.001,
		"rotated parent -> expected world point for local sign")
	_check(scene.visitor.collision_mask == 9 and scene.kiosk_zone.collision_mask == 2,
		"solid/gate blocking and sensor filtering are distinct")

	await _place(0, 0.82)
	scene.test_input = Vector2.UP
	await _ticks(44)
	_check(scene.visitor.global_position.z < -0.62 and not scene.gate_exception,
		"south approach crosses; permission clears after body clears")

	await _place(0, -0.82)
	scene.test_input = Vector2.DOWN
	await _ticks(44)
	_check(scene.visitor.global_position.z < -0.33 and scene.visitor.get_slide_collision_count() > 0,
		"north approach blocks against actual gate collider")

	await _place(0, 0.54)
	scene.test_input = Vector2.UP
	await _ticks(11)
	_check(scene.gate_exception and absf(scene.visitor.global_position.z) < 0.23,
		"mid-slab visitor has latched permission")
	scene.test_input = Vector2.DOWN
	await _ticks(22)
	_check(scene.visitor.global_position.z > 0.59 and not scene.gate_exception,
		"retreat mid-slab is permitted; exception removed after clearing south")

	await _place(-2.0, 0.82)
	scene.test_input = Vector2.UP
	await _ticks(44)
	_check(scene.visitor.global_position.z > 0.33 and scene.visitor.get_slide_collision_count() > 0,
		"divider away from portal still blocks north travel")

	await _place(3.5, -0.82)
	scene.test_input = Vector2.DOWN
	await _ticks(44)
	_check(scene.visitor.global_position.z > 0.64, "east return lane has no false gate block")

	await _place(0, 2.75)
	_check(not scene.press_kiosk() and scene.kiosk.stage == 0, "outside action makes no state change")
	scene.test_input = Vector2.UP
	await _ticks(106)
	scene.test_input = Vector2.LEFT
	await _ticks(50)
	scene.test_input = Vector2.ZERO
	await _ticks(4)
	_check(scene.visitor.global_position.distance_to(Vector3(-2.5, 0.61, -2.55)) < 0.10,
		"continuous physics route from spawn through gate reaches northwest zone")
	_check(scene.kiosk.inside and scene.kiosk.stage == 0, "actual Area3D signal enters without advance")
	var hold := InputEventKey.new()
	hold.physical_keycode = KEY_SPACE
	hold.pressed = true
	hold.echo = true
	scene._unhandled_key_input(hold)
	_check(scene.kiosk.stage == 0, "key repeat cannot silently open details")
	_check(scene.press_kiosk() and scene.kiosk.stage == 1, "in-zone first action opens detail")
	await _place(0, 2.2)
	_check(not scene.kiosk.inside and not scene.press_kiosk() and scene.kiosk.stage == 1,
		"exit hides prompt, rejects outside repeat, preserves detail")
	await _place(-2.5, -2.55)
	_check(scene.kiosk.inside and scene.kiosk.stage == 1, "re-entry resumes saved state without auto-completion")
	_check(scene.press_kiosk() and not scene.press_kiosk() and scene.kiosk.stage == 2,
		"second action completes; further action is idempotent")

	await _place(0, 2.2)
	scene.kiosk_zone.collision_mask = 0
	await _place(-2.5, -2.55)
	_check(not scene.kiosk.inside, "geometrical overlap is insufficient when mask excludes visitor")
	await _place(0, 2.2)
	scene.kiosk_zone.collision_mask = 2
	await _place(-2.5, -2.55)
	_check(scene.kiosk.inside, "restored mask reports overlap")

	scene.test_input = Vector2.RIGHT
	await _ticks(120)
	scene.test_input = Vector2.DOWN
	await _ticks(90)
	scene.test_input = Vector2.ZERO
	await _ticks(4)
	_check(scene.visitor.global_position.distance_to(Vector3(3.5, 0.61, 1.95)) < 0.12 and not scene.kiosk.inside,
		"continuous physics route leaves kiosk and completes east return")

	_check(scene.busy_branch.get_child_count() == 48 and not scene.busy_branch.visible,
		"profiling branch has 48 primitive meshes and starts hidden")
	print("ENGINE CHECKS ", tests - failures, "/", tests)
	quit(failures)
