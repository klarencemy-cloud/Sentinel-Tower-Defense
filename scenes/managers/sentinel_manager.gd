extends Node

var sentinel_scene = preload("res://scenes/sentinels/sentinel_system_administrator.tscn")
var level_root: Node2D
var level_manager: Node
var current_placement_kind: String = ""
var selected_sentinel: Data.Sentinel
var used_cells: Array[Vector2i] = []

var place_sentinel: bool = false:
	set(value):
		place_sentinel = value
		if is_inside_tree():
			var preview = _get_sentinel_preview()
			if preview:
				preview.visible = value


func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func handle_input(event: InputEvent) -> void:
	print("fawefeaw")
	var cell_pos = level_manager.mouse_to_map_position()
	var world_pos = level_manager.map_to_world(cell_pos)

	if event is InputEventMouseButton and event.button_mask == 1 and place_sentinel:
		_try_place_sentinel_current(cell_pos, world_pos)

	if event is InputEventMouseMotion and place_sentinel:
		var preview = _get_sentinel_preview()
		if preview:
			preview.position = world_pos

	if Input.is_action_just_pressed("exit"):
		cancel_selection()


func start_sentinel_placement(sentinel_type: Data.Sentinel) -> void:
	place_sentinel = true
	current_placement_kind = "sentinel"
	selected_sentinel = sentinel_type

	var preview = _get_sentinel_preview()
	if preview:
		preview.texture = load(Data.SENTINEL_DATA[sentinel_type]["thumbnail"])
		preview.scale = Vector2(0.5, 0.5)
		preview.offset = Vector2(0, -35)


func cancel_selection() -> void:
	place_sentinel = false
	current_placement_kind = ""


func _try_place_sentinel_current(cell_pos: Vector2i, world_pos: Vector2) -> void:
	if current_placement_kind == "sentinel":
		_try_place_sentinel(cell_pos, world_pos)

func _try_place_sentinel(cell_pos: Vector2i, world_pos: Vector2) -> void:
	var layer = level_manager.get_build_layer()
	if layer == null:
		return

	var tile_data = layer.get_cell_tile_data(cell_pos) as TileData
	if cell_pos in used_cells:
		return
	if tile_data == null or not tile_data.get_custom_data("Usable"):
			return

	used_cells.append(cell_pos)

	var sentinel = sentinel_scene.instantiate()
	sentinel.position = world_pos
	level_root.get_node("Sentinels").add_child(sentinel)

	place_sentinel = false

func _get_sentinel_preview() -> Sprite2D:
	var preview = level_root.get_node_or_null("BG/TowerPreview")
	return preview as Sprite2D
