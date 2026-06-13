extends Node


#@export var default_map_path := "res://scenes/levels/level1.scn"
#@export var current_map_name := "Level1"
#@export var build_layer_path := NodePath("Pavement")

@export var default_map_path: String
@export var current_map_name: String
@export var build_layer_path := NodePath("Pavement")

@onready var victory_overlay = $UI/VictoryOverlay

var level_root: Node2D
var current_map: Node


var levels := [
	"res://scenes/levels/level1.scn",
	"res://scenes/levels/level2.scn",
	"res://scenes/levels/level3.scn"
]

func _ready() -> void:
	randomize()
	lightning()
	take_map_level()


func take_map_level() -> void:
	print("this is " + str(Data.current_level_index))
	default_map_path = levels[Data.current_level_index]
	current_map_name = ("Level" + str(Data.current_level_index + 1))

func setup(root: Node2D) -> void:
	level_root = root
	current_map = level_root.get_node_or_null(current_map_name)
	if current_map == null:
		load_map(default_map_path)


func load_map(map_path: String) -> Node:
	if current_map:
		current_map.queue_free()

	var map_scene = load(map_path)
	if map_scene == null:
		push_error("LevelManager could not load map: " + map_path)
		return null

	current_map = map_scene.instantiate()
	current_map.name = current_map_name
	if current_map is CanvasItem:
		current_map.z_index = -1
	level_root.add_child(current_map)
	level_root.move_child(current_map, 0)
	return current_map


func get_build_layer() -> TileMapLayer:
	if current_map:
		var map_layer = current_map.get_node_or_null(build_layer_path)
		if map_layer is TileMapLayer:
			return map_layer

	var fallback_layer = level_root.get_node_or_null("BG/TileMapLayer")
	if fallback_layer is TileMapLayer:
		return fallback_layer

	return null


func map_to_world(cell_pos: Vector2i) -> Vector2:
	return Vector2(cell_pos * 16 + Vector2i(8, 8))


func mouse_to_map_position() -> Vector2i:
	var layer = get_build_layer()
	if layer == null:
		return Vector2i.ZERO

	return layer.local_to_map(level_root.get_local_mouse_position())


@onready var light_node = $"../WeatherEffects/LightningEffects"

@onready var min_energy: float = light_node.min_energy
@onready var max_energy: float = light_node.max_energy
@onready var min_interval: float = light_node.min_interval
@onready var max_interval: float = light_node.max_interval


func lightning() -> void:
	while true:
		var light: float = randf_range(min_energy, max_energy)
		var delay: float = randf_range(min_interval, max_interval)
		await get_tree().create_timer(delay).timeout

		light_node.energy = light

		await get_tree().create_timer(randf_range(.1, .3)).timeout
		light_node.energy = 0.0


