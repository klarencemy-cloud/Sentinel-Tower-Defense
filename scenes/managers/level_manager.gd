extends Node

@export var default_map_path: String
@export var current_map_name: String
@export var build_layer_path: NodePath = ("Pavement")
@export var asset_layer_path: NodePath = ("Assets")

var level_root: Node2D
var current_map: Node

var levels: Array = [
	"res://scenes/levels/level1.scn",
	"res://scenes/levels/level2.scn",
	"res://scenes/levels/level3.scn",
	"res://scenes/levels/level4.scn",
	"res://scenes/levels/level5.scn",
	"res://scenes/levels/level6.scn"
]

func _ready() -> void:
	randomize()
	lightning()
	take_map_level()

	add_to_group("retry_game")


func take_map_level() -> void:
	default_map_path = levels[Data.current_level_index]
	current_map_name = ("Level" + str(Data.current_level_index + 1))


func _reset_map_level() -> void:
	Data.current_level_index = 0
	Data.clear_notpetya_enemy_speed_effect()
	default_map_path = levels[Data.current_level_index]
	current_map_name = ("Level" + str(Data.current_level_index + 1))
	get_tree().change_scene_to_file("uid://h7qi8y7uyyai") # Loading screen


func setup(root: Node2D) -> void:
	level_root = root
	current_map = level_root.get_node_or_null(current_map_name)
	if current_map == null:
		load_map(default_map_path)


func load_map(map_path: String) -> Node:
	Data.currentserverload = 0
	Data.backup_server_placed = false
	Data.free_towers = Data.owned_towers.duplicate(true)
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()
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

	# Set the camera limits from the current map's WorldBoundary
	var camera = get_tree().get_first_node_in_group("camera")
	if camera:
		var boundary = current_map.get_node_or_null("WorldBoundary")
		if boundary:
			camera.set_world_bounds(boundary)

	_enemy_container()

	return current_map

func _enemy_container() -> void: # Puts enemies from multiple paths from multiple container
	var container = level_root.get_node_or_null("EnemyContainer")
	if container == null:
		container = Node2D.new()
		container.name = "EnemyContainer"
		level_root.add_child(container)
	level_root.move_child(container, 1)


func get_build_layer() -> TileMapLayer:
	if current_map:
		var map_layer = current_map.get_node_or_null(build_layer_path)
		if map_layer is TileMapLayer:
			return map_layer

	var fallback_layer = level_root.get_node_or_null("BG/TileMapLayer")
	if fallback_layer is TileMapLayer:
		return fallback_layer

	return null

func get_asset_layer() -> TileMapLayer:
	if current_map:
		var asset_layer = current_map.get_node_or_null(asset_layer_path)
		if asset_layer is TileMapLayer:
			return asset_layer

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
		
func world_to_map(world_pos: Vector2) -> Vector2i:
	return Vector2i(floor(world_pos.x / 16.0), floor(world_pos.y / 16.0))
