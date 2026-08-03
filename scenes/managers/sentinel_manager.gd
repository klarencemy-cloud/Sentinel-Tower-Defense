extends Node


var sentinel_scenes = {
	Data.Sentinel.ETHICAL: "res://scenes/sentinels/sentinel_ethical_hacker.tscn",
	Data.Sentinel.SYSAD: "res://scenes/sentinels/sentinel_system_administrator.tscn",
	Data.Sentinel.INTRUSION: "res://scenes/sentinels/sentinel_intrusion_analyst.tscn",
	Data.Sentinel.SECURITY: "res://scenes/sentinels/sentinel_security_architect.tscn",
	Data.Sentinel.MALWARE: "res://scenes/sentinels/sentinel_malware_analyst.tscn",
	Data.Sentinel.DECEPTION: "res://scenes/sentinels/sentinel_deception_analyst.tscn"
}


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
		preview.scale = Vector2(0.65, 0.65)
		preview.offset = Vector2(0, -165)


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
	print(tile_data)
	print(tile_data.get_custom_data("Usable"))
	print(Data.is_tower_placeable)
	print(layer == null)
	# if cell_pos in used_cells:
	# 	return
	if tile_data == null or not tile_data.get_custom_data("Usable"):
		return


	if not Data.is_tower_placeable:
		return

	used_cells.append(cell_pos)

	var sentinel = load(sentinel_scenes[selected_sentinel]).instantiate()
	sentinel.position = world_pos
	level_root.get_node("Towers").add_child(sentinel)
	place_sentinel = false

	match selected_sentinel:
		0:
			Data.sentinel_ethical_deployed = true
			Data.deactivate.emit()
		1:
			Data.sentinel_sysad_deployed = true
			Data.deactivate.emit()
		2:
			Data.sentinel_intrusion_deployed = true
			Data.deactivate.emit()
		3:
			Data.sentinel_security_deployed = true
			Data.deactivate.emit()
		4:
			Data.sentinel_malware_deployed = true
			Data.deactivate.emit()
		5:
			Data.sentinel_deception_deployed = true
			Data.deactivate.emit()


func _get_sentinel_preview() -> Sprite2D:
	var preview = level_root.get_node_or_null("BG/SentinelPreview")
	return preview as Sprite2D
