extends Node

var tower_scenes = {
	Data.Tower.BASIC: "res://scenes/towers/tower_basic.tscn",
	Data.Tower.BLAST: "res://scenes/towers/tower_blaster.tscn",
	Data.Tower.MORTAR: "res://scenes/towers/tower_mortar.tscn",
	Data.Tower.SPAM_FILTER: "res://scenes/towers/tower_spamfilter.tscn",
	Data.Tower.QUARANTINE_CANNON: "res://scenes/towers/tower_quarantinecannon.tscn",
	Data.Tower.IDPS: "res://scenes/towers/tower_idps.tscn"
}

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")
var explosion_scene = preload("res://scenes/bullets/explosion.tscn")

var level_root: Node2D
var level_manager: Node
var selected_tower: Data.Tower
var current_tower: Tower
var tower_menu: bool = false
var next_tower_id: int = 1
var used_cells: Array[Vector2i] = []

var place_tower: bool = false:
	set(value):
		place_tower = value
		if is_inside_tree():
			var preview = _get_tower_preview()
			if preview:
				preview.visible = value


func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func handle_input(event: InputEvent) -> void:
	var cell_pos = level_manager.mouse_to_map_position()
	var world_pos = level_manager.map_to_world(cell_pos)

	if event is InputEventMouseButton and event.button_mask == 1 and place_tower:
		_try_place_tower(cell_pos, world_pos)

	if event is InputEventMouseButton and event.button_mask == 1 and current_tower:
		if current_tower.type == Data.Tower.MORTAR or current_tower.type == Data.Tower.QUARANTINE_CANNON:
			current_tower.finish_placing()
			current_tower = null

	if event is InputEventMouseMotion and tower_menu:
		if current_tower and (current_tower.type == Data.Tower.MORTAR or current_tower.type == Data.Tower.QUARANTINE_CANNON):
			current_tower.crosshair_pos_update(world_pos)

	if event is InputEventMouseMotion and place_tower:
		var preview = _get_tower_preview()
		if preview:
			preview.position = world_pos

	if Input.is_action_just_pressed("exit"):
		cancel_selection()


func start_tower_placement(tower_type: Data.Tower) -> void:
	place_tower = true
	selected_tower = tower_type

	var preview = _get_tower_preview()
	if preview:
		preview.texture = load(Data.TOWER_DATA[tower_type]["thumbnail"])


func cancel_selection() -> void:
	place_tower = false
	tower_menu = false
	current_tower = null

	for tower in get_tree().get_nodes_in_group("Towers"):
		tower.hide_ui()


func create_bullet(pos: Vector2, angle: float, bullet_enum: Data.Bullet, damage: int, tower_type, tower_id: int = -1) -> void:
	if bullet_enum == Data.Bullet.SINGLE:
		var bullet = bullet_scene.instantiate()
		bullet.setup(pos, angle, bullet_enum, damage, tower_type, tower_id)
		_get_bullet_parent().add_child(bullet)

	if bullet_enum == Data.Bullet.FIRE:
		# Get the tower's range from data
		var tower_range = 100  # default fallback
		if tower_type != null:
			var tower_data = Data.TOWER_DATA.get(tower_type, null)
			if tower_data:
				tower_range = tower_data.get("range", 100)
		
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if pos.distance_to(enemy.global_position) < tower_range:
				# IDPS can hit invisible enemies and disables their invisibility
				if tower_type == Data.Tower.IDPS and enemy.invisible:
					enemy.set_invisible(false)
				enemy.hit(damage, tower_id)

	if bullet_enum == Data.Bullet.MORTAR_EXPLOSION:
		var explosion = explosion_scene.instantiate()
		explosion.setup(pos, damage, tower_type, tower_id)
		_get_bullet_parent().add_child(explosion)


func tower_selection(tower: Tower) -> void:
	if current_tower and current_tower != tower:
		current_tower.hide_ui()

	current_tower = tower
	tower_menu = true

	if tower.type == Data.Tower.MORTAR or tower.type == Data.Tower.QUARANTINE_CANNON:
		tower.show_crosshair()

	tower.show_range()


func _try_place_tower(cell_pos: Vector2i, world_pos: Vector2) -> void:
	var layer = level_manager.get_build_layer()
	if layer == null:
		return

	var tile_data = layer.get_cell_tile_data(cell_pos) as TileData
	if cell_pos in used_cells:
		return
	if tile_data == null or not tile_data.get_custom_data("Usable"):
		return

	var cost = Data.TOWER_DATA[selected_tower]["cost"]
	var systemload = Data.TOWER_DATA[selected_tower]["server_load"]
	
	if Data.currentserverload >= Data.maxserverload:
		place_tower = false
		return
		
	if not Data.is_unli_money and Data.money < cost:
		place_tower = false
		return

	used_cells.append(cell_pos)

	var tower = load(tower_scenes[selected_tower]).instantiate()
	tower.tower_id = next_tower_id
	next_tower_id += 1
	tower.position = world_pos
	tower.setup(selected_tower)
	tower.cell_pos = cell_pos
	tower.connect("shoot", create_bullet)
	tower.connect("select", tower_selection)
	tower.connect("removed", _on_tower_removed)
	_get_tower_parent().add_child(tower)
	EnemyTower.register_tower(tower.tower_id, selected_tower)

	place_tower = false
	if not Data.is_unli_money:
		Data.money -= cost
	
	Data.currentserverload += systemload
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()

	print("Placed tower ID: ", tower.tower_id)

func _on_tower_removed(cell_pos: Vector2i) -> void:
	if cell_pos in used_cells:
		used_cells.erase(cell_pos)

	if current_tower and current_tower.cell_pos == cell_pos:
		current_tower = null


func _get_tower_parent() -> Node:
	return level_root.get_node("Towers")


func _get_bullet_parent() -> Node:
	return level_root.get_node("Bullets")


func _get_tower_preview() -> Sprite2D:
	var preview = level_root.get_node_or_null("BG/TowerPreview")
	return preview as Sprite2D
