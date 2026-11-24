extends SceneTree
## Same camera/scene: collect real monotonic intervals, not fixed movie-frame time.

const WARMUP := 48
const SAMPLES := 120
var gal


func _initialize() -> void:
	if DisplayServer.get_name() == "headless" or OS.has_feature("dedicated_server"):
		push_error("Profiler needs a windowed renderer. Headless is for logic checks.")
		quit(2)
		return
	call_deferred("_run")


func _phase(crowded: bool) -> Dictionary:
	gal.busy_branch.visible = crowded
	gal._refresh()
	for i in range(WARMUP):
		await process_frame
	var intervals: Array[float] = []
	var draws: Array[float] = []
	var start := Time.get_ticks_usec()
	for i in range(SAMPLES):
		await process_frame
		var now := Time.get_ticks_usec()
		intervals.append(float(now - start) * 0.001)
		draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
		start = now
	intervals.sort()
	draws.sort()
	return {"dense_visible": crowded, "samples": intervals.size(), "median_frame_interval_ms":
		(intervals[SAMPLES / 2 - 1] + intervals[SAMPLES / 2]) / 2.0,
		"p95_frame_interval_ms": intervals[int(ceil(0.95 * SAMPLES)) - 1],
		"maximum_frame_interval_ms": intervals.back(),
		"median_draw_call_monitor": (draws[SAMPLES / 2 - 1] + draws[SAMPLES / 2]) / 2.0}


func _run() -> void:
	gal = load("res://gallery.tscn").instantiate()
	root.add_child(gal)
	gal.use_test_input = true
	var phases: Array[Dictionary] = []
	for on in [false, true, true, false]:
		phases.append(await _phase(on))
	var report := {"engine": Engine.get_version_info().get("string"),
		"os": OS.get_name(), "adapter": RenderingServer.get_video_adapter_name(),
		"viewport": [root.size.x, root.size.y],
		"warning": "Stationary camera and spawn; human route and frame capacity not certified.",
		"results": phases}
	print("PROFILE ", JSON.stringify(report))
	quit()
