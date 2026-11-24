extends Node3D
## The world is primitive geometry. There are no downloads or external assets.

const Kiosk = preload("res://kiosk_session.gd")
const SOLID := 1
const VISITOR := 2
const SENSOR := 4
const GATE := 8
const SPEED := 3.0
# Barrier half-thickness .08 + visitor radius .30; require .44 to clear.
const CLEAR_Z := 0.44
const ENTRY_Z := 0.65

var visitor: CharacterBody3D
var gate: StaticBody3D
var kiosk_zone: Area3D
var sign_anchor: Marker3D
var busy_branch: Node3D
var readout: Label
var kiosk := Kiosk.new()
var gate_exception := false
var use_test_input := false
var test_input := Vector2.ZERO


func _ready() -> void:
	_bind("walk_left", [KEY_A, KEY_LEFT])
	_bind("walk_right", [KEY_D, KEY_RIGHT])
	_bind("walk_north", [KEY_W, KEY_UP])
	_bind("walk_south", [KEY_S, KEY_DOWN])
	_bind("visit_kiosk", [KEY_SPACE])
	_bind("toggle_crowd", [KEY_F])
	_build_environment()
	_build_player()
	_build_camera_and_light()
	_build_readout()


func _bind(action: StringName, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var input_event := InputEventKey.new()
		input_event.physical_keycode = key
		if not InputMap.action_has_event(action, input_event):
			InputMap.action_add_event(action, input_event)


func _box(parent: Node3D, where: Vector3, dimensions: Vector3, color: Color) -> MeshInstance3D:
	var result := MeshInstance3D.new()
	var shape := BoxMesh.new()
	shape.size = dimensions
	var paint := StandardMaterial3D.new()
	paint.albedo_color = color
	paint.roughness = 0.85
	result.mesh = shape
	result.material_override = paint
	result.position = where
	parent.add_child(result)
	return result


func _barrier(where: Vector3, dimensions: Vector3, layer: int, show_mesh: bool) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.position = where
	body.collision_layer = layer
	body.collision_mask = VISITOR
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
	add_child(body)
	if show_mesh:
		_box(body, Vector3.ZERO, dimensions, Color("40556a"))
	return body


func _legend(parent: Node3D, where: Vector3, words: String) -> Label3D:
	var label := Label3D.new()
	label.position = where
	label.text = words
	label.font_size = 48
	label.pixel_size = 0.008
	label.outline_size = 9
	label.outline_modulate = Color("162132")
	label.modulate = Color("ffffff")
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	parent.add_child(label)
	return label


func _build_environment() -> void:
	_box(self, Vector3(0, -0.10, 0), Vector3(10, 0.20, 10), Color("8199a7"))
	_barrier(Vector3(0, 0.5, -5), Vector3(10, 1, 0.16), SOLID, true)
	_barrier(Vector3(0, 0.5, 5), Vector3(10, 1, 0.16), SOLID, true)
	_barrier(Vector3(-5, 0.5, 0), Vector3(0.16, 1, 10), SOLID, true)
	_barrier(Vector3(5, 0.5, 0), Vector3(0.16, 1, 10), SOLID, true)
	# The divider has a one-way north entry and a different, ordinary opening to the east.
	_barrier(Vector3(-2.95, 0.5, 0), Vector3(4.10, 1, 0.16), SOLID, true)
	_barrier(Vector3(1.75, 0.5, 0), Vector3(1.70, 1, 0.16), SOLID, true)
	_barrier(Vector3(4.70, 0.5, 0), Vector3(0.60, 1, 0.16), SOLID, true)
	gate = _barrier(Vector3(0, 0.5, 0), Vector3(1.80, 1, 0.16), GATE, false)

	var door_frame := Node3D.new()
	door_frame.name = "ExhibitFrame"
	door_frame.position = Vector3(2, 0, -1)
	door_frame.rotation_degrees.y = 90
	add_child(door_frame)
	sign_anchor = Marker3D.new()
	sign_anchor.name = "LocalSign"
	sign_anchor.position = Vector3(1, 1.8, 0.2)
	door_frame.add_child(sign_anchor)
	_legend(sign_anchor, Vector3.ZERO, "READING ROOM")

	# Mark the north entrance with three separate chevrons.
	for z in [0.46, 0.98, 1.50]:
		for s in [-1, 1]:
			var stroke := _box(self, Vector3(s * 0.13, 0.026, z),
				Vector3(0.09, 0.03, 0.40), Color("f9f5d6"))
			stroke.rotation_degrees.y = s * 41
	_legend(self, Vector3(0, 0.42, 0.4), "ENTRY NORTH")
	# The east return route has wide, transverse bars and a separate text label.
	for z in [-0.62, 0.55]:
		_box(self, Vector3(3.5, 0.03, z), Vector3(1.20, 0.035, 0.13), Color("f9f5d6"))
	_legend(self, Vector3(3.5, 0.42, 0.4), "EAST RETURN")
	_box(self, Vector3(-2.5, 0.026, -2.55), Vector3(1.85, 0.04, 1.7), Color("203848"))
	_barrier(Vector3(-2.5, 0.37, -3.83), Vector3(1.0, 0.74, 0.57), SOLID, true)
	_legend(self, Vector3(-2.5, 1.3, -3.78), "I / KIOSK")

	kiosk_zone = Area3D.new()
	kiosk_zone.name = "KioskSensor"
	kiosk_zone.position = Vector3(-2.5, 0.60, -2.55)
	kiosk_zone.collision_layer = SENSOR
	kiosk_zone.collision_mask = VISITOR
	kiosk_zone.monitorable = false
	var sense_shape := CollisionShape3D.new()
	var region := BoxShape3D.new()
	region.size = Vector3(1.8, 1.20, 1.7)
	sense_shape.shape = region
	kiosk_zone.add_child(sense_shape)
	add_child(kiosk_zone)
	kiosk_zone.body_entered.connect(_kiosk_entered)
	kiosk_zone.body_exited.connect(_kiosk_exited)

	busy_branch = Node3D.new()
	busy_branch.name = "CrowdedDecorations"
	add_child(busy_branch)
	for i in range(48):
		var height := 0.18 + 0.20 * float(i % 4)
		_box(busy_branch, Vector3(1.32 + 0.39 * float(i % 8), height / 2.0,
			-4.48 + 0.34 * floorf(float(i) / 8.0)), Vector3(0.25, height, 0.23), Color("a6b49a"))
	busy_branch.hide()


func _build_player() -> void:
	visitor = CharacterBody3D.new()
	visitor.name = "Visitor"
	visitor.position = Vector3(0, 0.61, 2.75)
	visitor.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	visitor.collision_layer = VISITOR
	visitor.collision_mask = SOLID | GATE
	var h := CapsuleShape3D.new()
	h.radius = 0.30
	h.height = 1.20
	var collider := CollisionShape3D.new()
	collider.shape = h
	visitor.add_child(collider)
	var shape := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.30
	capsule.height = 1.20
	shape.mesh = capsule
	var p := StandardMaterial3D.new()
	p.albedo_color = Color("f8d76d")
	shape.material_override = p
	visitor.add_child(shape)
	add_child(visitor)


func _build_camera_and_light() -> void:
	var world := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("11192b")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color("dce8ff")
	e.ambient_light_energy = 0.57
	world.environment = e
	add_child(world)
	var lamp := DirectionalLight3D.new()
	lamp.rotation_degrees = Vector3(-58, -20, 0)
	lamp.light_energy = 0.90
	add_child(lamp)
	var camera := Camera3D.new()
	camera.position = Vector3(0, 10, 9)
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 12.9
	add_child(camera)
	camera.look_at(Vector3(0, 0.2, 0))
	camera.current = true


func _build_readout() -> void:
	var hud := CanvasLayer.new()
	add_child(hud)
	var panel := ColorRect.new()
	panel.color = Color("172538")
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	panel.offset_bottom = 106
	readout = Label.new()
	readout.position = Vector2(16, 8)
	readout.add_theme_font_size_override("font_size", 19)
	panel.add_child(readout)
	_refresh()


func _refresh() -> void:
	readout.text = ("READING ROOM RELAY\nArrows/WASD: Walk | Space: Kiosk | F: Decor (" +
		("on" if busy_branch.visible else "off") + ")\n" + kiosk.cue())


func _kiosk_entered(body: Node3D) -> void:
	if body == visitor:
		kiosk.enter()
		_refresh()


func _kiosk_exited(body: Node3D) -> void:
	if body == visitor:
		kiosk.leave()
		_refresh()


func press_kiosk() -> bool:
	var changed := kiosk.press()
	_refresh()
	return changed


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event.is_action_pressed("visit_kiosk"):
		press_kiosk()
	elif event.is_action_pressed("toggle_crowd"):
		busy_branch.visible = not busy_branch.visible
		_refresh()


func _set_gate_exception(next: bool) -> void:
	if next == gate_exception:
		return
	gate_exception = next
	if next:
		visitor.add_collision_exception_with(gate)
	else:
		visitor.remove_collision_exception_with(gate)


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("walk_left", "walk_right", "walk_north", "walk_south")
	if use_test_input:
		direction = test_input.limit_length()
	var p := visitor.global_position
	if gate_exception and (p.z <= -CLEAR_Z or (p.z >= CLEAR_Z and direction.y >= 0)):
		_set_gate_exception(false)
	if (not gate_exception and absf(p.x) < 1.20 and p.z > 0.0 and
		p.z <= ENTRY_Z and direction.y < 0.0):
		_set_gate_exception(true)
	visitor.velocity = Vector3(direction.x, 0.0, direction.y) * SPEED
	visitor.move_and_slide()
