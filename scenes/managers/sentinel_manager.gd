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
var preview_initialized := false
var range_indicator: Line2D

var place_sentinel: bool = false:
	set(value):
		place_sentinel = value
		Data.is_placing_tower = value

		if is_inside_tree():
			var preview = _get_sentinel_preview()
			if preview:
				preview.visible = value


func _ready() -> void:
	Data.cancel_sentinel_placement.connect(cancel_selection)

func _process(delta: float) -> void:
	var preview = _get_sentinel_preview()
	var place_btn = preview.get_node("PlaceTower")
	var range_indicator = preview.get_node_or_null("RangeIndicator") as Line2D
	if Data.is_sentinel_placeable:
		place_btn.show()
		preview.modulate = Color.WHITE
		range_indicator.default_color = Color(1, 1, 1, 0.7)
	else:
		place_btn.hide()
		preview.modulate = Color(1.0, 0.4, 0.4, 0.8)
		range_indicator.default_color = Color(1.0, 0.2, 0.2, 0.8)

func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager
	
	
func handle_input(event: InputEvent) -> void:
	var cell_pos = level_manager.mouse_to_map_position()
	var world_pos = level_manager.map_to_world(cell_pos)

	if place_sentinel:
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var preview = _get_sentinel_preview()

			if preview:
				if !preview.visible:
					preview.show()

				if !preview_initialized:
					preview.show()
					preview_initialized = true

				preview.position = world_pos
				_update_preview_buttons(cell_pos, preview)

		elif event is InputEventScreenDrag:
			var preview = _get_sentinel_preview()

			if preview:
				if !preview.visible:
					preview.show()

				preview.position = world_pos
				_update_preview_buttons(cell_pos, preview)

	if Input.is_action_just_pressed("exit"):
		cancel_selection()

func start_sentinel_placement(sentinel_type: Data.Sentinel) -> void:
	Data.cancel_tower_placement.emit()
	place_sentinel = true
	current_placement_kind = "sentinel"
	selected_sentinel = sentinel_type

	var preview = _get_sentinel_preview()

	if preview:
		preview.show()
		preview_initialized = false

		var camera = get_tree().get_first_node_in_group("camera")

		preview.position = camera.position

		# Set the preview scale BEFORE calculating the range
		preview.scale = Vector2(0.65, 0.65)

		preview.texture = load(Data.SENTINEL_DATA[sentinel_type]["thumbnail"])
		preview.offset = Vector2(0, -165)
		preview.modulate = Color.WHITE

		# Create/get the range indicator
		create_range_indicator(preview)

		# Get the sentinel's actual range from Data.gd
		var sentinel_data = Data.SENTINEL_DATA.get(sentinel_type, {})
		var sentinel_range: float = float(sentinel_data.get("range", 0))

		if sentinel_range > 0:
			update_range_indicator(preview, sentinel_range)
		elif range_indicator:
			range_indicator.visible = false

		var cell_pos = level_manager.world_to_map(preview.position)

		_update_preview_buttons(cell_pos, preview)

		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		place_btn.show()
		cancel_btn.show()

		if not place_btn.pressed.is_connected(confirm_current_placement):
			place_btn.pressed.connect(confirm_current_placement)

		if not cancel_btn.pressed.is_connected(cancel_current_placement):
			cancel_btn.pressed.connect(cancel_current_placement)
			
			

func cancel_selection() -> void:
	if range_indicator:
		range_indicator.visible = false
	place_sentinel = false
	current_placement_kind = ""

	var preview = _get_sentinel_preview()

	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview.position = Vector2.ZERO
		preview_initialized = false

		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		place_btn.hide()
		cancel_btn.hide()


func _try_place_sentinel_current(cell_pos: Vector2i, world_pos: Vector2) -> void:
	if current_placement_kind == "sentinel":
		_try_place_sentinel(cell_pos, world_pos)

func _try_place_sentinel(cell_pos: Vector2i, world_pos: Vector2) -> void:
	var layer = level_manager.get_build_layer()
	if layer == null:
		return


	var tile_data = layer.get_cell_tile_data(cell_pos) as TileData

	# if cell_pos in used_cells:
	# 	return
	if tile_data == null or not tile_data.get_custom_data("Usable"):
		return


	if not Data.is_sentinel_placeable:
		return

	used_cells.append(cell_pos)

	var sentinel = load(sentinel_scenes[selected_sentinel]).instantiate()
	sentinel.position = world_pos
	level_root.get_node("Towers").add_child(sentinel)
	cancel_selection()

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
	
func confirm_current_placement():
	if !place_sentinel:
		return

	var preview = _get_sentinel_preview()

	if preview == null:
		return

	var world_pos = preview.position
	var cell_pos = level_manager.world_to_map(world_pos)

	_try_place_sentinel_current(cell_pos, world_pos)

func cancel_current_placement():
	if range_indicator:
		range_indicator.visible = false
	var preview = _get_sentinel_preview()

	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview.position = Vector2.ZERO
		preview_initialized = false

		preview.get_node("PlaceTower").hide()
		preview.get_node("CancelPlace").hide()

	cancel_selection()

func _update_preview_buttons(cell_pos: Vector2i, preview: Sprite2D):
	var place_btn = preview.get_node("PlaceTower")

	var layer = level_manager.get_build_layer()

	var valid := true

	var tile = layer.get_cell_tile_data(cell_pos)

	if tile == null:
		valid = false
	elif !tile.get_custom_data("Usable"):
		valid = false

	if !Data.is_sentinel_placeable:
		valid = false

	place_btn.visible = valid

	var range_indicator = preview.get_node_or_null("RangeIndicator") as Line2D

	if valid:
		preview.modulate = Color.WHITE

		if range_indicator:
			range_indicator.default_color = Color(1, 1, 1, 0.7)
	else:
		preview.modulate = Color(1.0, 0.4, 0.4, 0.8)

		if range_indicator:
			range_indicator.default_color = Color(1.0, 0.2, 0.2, 0.8)

func create_range_indicator(preview: Sprite2D) -> void:
	if range_indicator:
		return

	range_indicator = preview.get_node_or_null("RangeIndicator") as Line2D

	if range_indicator == null:
		return

	range_indicator.width = 2
	range_indicator.default_color = Color(1, 1, 1, 0.7)
	range_indicator.visible = false
	range_indicator.z_index = 100
	
func update_range_indicator(preview: Sprite2D, radius: float) -> void:
	if not range_indicator:
		return

	var points := PackedVector2Array()
	var segments := 100

	for i in range(segments + 1):
		var angle := TAU * i / segments
		points.append(Vector2(cos(angle), sin(angle)) * radius)

	range_indicator.points = points

	# Counteract the SentinelPreview scale
	range_indicator.scale = Vector2.ONE / preview.scale

	range_indicator.visible = true
