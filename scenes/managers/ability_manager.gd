extends Node

var firewall_scene = preload("res://scenes/abilities/firewall.tscn")
var level_root: Node2D
var level_manager: Node
var current_placement_kind: String = ""
var preview_initialized := false
var selected_ability: Data.Ability

var place_ability: bool = false:
	set(value):
		place_ability = value
		Data.is_placing_tower = value

		if is_inside_tree():
			var preview = _get_ability_preview()
			if preview:
				preview.visible = value

func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func handle_input(event: InputEvent) -> void:
	var world_pos = level_manager.map_to_world(level_manager.mouse_to_map_position())

	if place_ability:
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var preview = _get_ability_preview()

			if preview:
				if !preview.visible:
					preview.show()

				if !preview_initialized:
					preview.show()
					preview_initialized = true

				preview.position = world_pos
				_update_preview_buttons(world_pos, preview)

		elif event is InputEventScreenDrag:
			var preview = _get_ability_preview()

			if preview:
				preview.position = world_pos
				_update_preview_buttons(world_pos, preview)

	if Input.is_action_just_pressed("exit"):
		cancel_selection()
		


func start_ability_placement(ability: Data.Ability) -> void:
	place_ability = true
	current_placement_kind = "ability"
	selected_ability = ability

	var preview = _get_ability_preview()
	if preview:
		preview.show()
		preview_initialized = false

		var camera = get_tree().get_first_node_in_group("camera")
		preview.position = camera.position
		preview.texture = preload("res://graphics/abilities/firewall.png")
		preview.scale = Vector2(.9, .9)
		preview.offset = Vector2(0, .1)

		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		cancel_btn.show()

		_update_preview_buttons(preview.position, preview)

		if !place_btn.pressed.is_connected(confirm_current_placement):
			place_btn.pressed.connect(confirm_current_placement)

		if !cancel_btn.pressed.is_connected(cancel_current_placement):
			cancel_btn.pressed.connect(cancel_current_placement)
			


func cancel_selection() -> void:
	place_ability = false
	current_placement_kind = ""

	var preview = _get_ability_preview()

	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview.position = Vector2.ZERO
		preview_initialized = false

		preview.get_node("PlaceTower").hide()
		preview.get_node("CancelPlace").hide()


func _try_place_ability(world_pos: Vector2) -> void:
	if current_placement_kind == "ability":
		_try_place_firewall(world_pos)


func _try_place_firewall(world_pos: Vector2) -> void:
	if not _is_on_path(world_pos):
		return

	var firewall_parent = level_root.get_node_or_null("Abilities")
	if firewall_parent == null:
		firewall_parent = Node2D.new()
		firewall_parent.name = "Abilities"
		level_root.add_child(firewall_parent)

	var firewall_instance = firewall_scene.instantiate()
	firewall_instance.position = world_pos
	firewall_parent.add_child(firewall_instance)

	cancel_selection()
	current_placement_kind = ""
	if Data.current_wave == 5 and !Data.is_sandbox and !GameDialogueManager.is_firewall_activated_shown:
		GameDialogueManager.show_dialogue_firewall_activated()

func _is_on_path(world_pos: Vector2) -> bool:
	var path_nodes: Array[Node] = []
	for child in level_root.get_children():
		if child is Path2D:
			path_nodes.append(child)
		else:
			for grandchild in child.get_children():
				if grandchild is Path2D:
					path_nodes.append(grandchild)

	for path in path_nodes:
		if path is Path2D:
			var local_pos = path.to_local(world_pos)
			var curve = path.curve
			if curve.get_point_count() < 2:
				continue
			var closest_point = curve.get_closest_point(local_pos)
			if closest_point.distance_to(local_pos) <= 35:
				return true
	return false


func _get_ability_preview() -> Sprite2D:
	var preview = level_root.get_node_or_null("BG/SkillPreview")
	return preview as Sprite2D

func confirm_current_placement():
	if !place_ability:
		return

	var preview = _get_ability_preview()

	if preview == null:
		return

	_try_place_ability(preview.position)

func cancel_current_placement():
	var preview = _get_ability_preview()

	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview.position = Vector2.ZERO
		preview_initialized = false

		preview.get_node("PlaceTower").hide()
		preview.get_node("CancelPlace").hide()

	cancel_selection()

func _update_preview_buttons(world_pos: Vector2, preview: Sprite2D):
	var place_btn = preview.get_node("PlaceTower")

	var valid := _is_on_path(world_pos)

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
