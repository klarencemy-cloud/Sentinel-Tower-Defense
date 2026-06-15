extends Node2D

@onready var progress_bar: ProgressBar = $Anchor/ProgressBar
@export var next_scene_path1: String = "res://scenes/levels/level.tscn"
@export var next_scene_path2: String = "res://scenes/sandbox/sand_box.tscn"
var next_scene_path: String
var progress: Array[float] = []



func _ready() -> void:
	if Data.is_sandbox:
		next_scene_path = next_scene_path2
		print("Sandbox mode enabled, loading sandbox scene...")
	else:
		next_scene_path = next_scene_path1

	ResourceLoader.load_threaded_request(next_scene_path)


func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100.0
			progress_bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
