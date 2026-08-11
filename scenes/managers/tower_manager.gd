extends Node

var tower_scenes = {
	Data.Tower.SPAM_FILTER: "res://scenes/towers/tower_spamfilter.tscn",
	Data.Tower.ANTIVIRUS: "res://scenes/towers/tower_antivirus.tscn",
	Data.Tower.DATA_LOSS_PREVENTION: "res://scenes/towers/tower_data_loss_prevention.tscn",
	Data.Tower.QUARANTINE_CANNON: "res://scenes/towers/tower_quarantinecannon.tscn",
	Data.Tower.IDPS: "res://scenes/towers/tower_idps.tscn",
	Data.Tower.BACKUP_SERVER: "res://scenes/towers/tower_backup_server.tscn",
	Data.Tower.SANDBOX_ANALYZER: "res://scenes/towers/tower_sandbox_analyzer.tscn",
	Data.Tower.AD_BLOCKER: "res://scenes/towers/tower_ad_blocker.tscn",
	Data.Tower.ACCESS_CONTROL_SYSTEM: "res://scenes/towers/tower_acs.tscn",
	Data.Tower.ENDPOINT_PROTECTION: "res://scenes/towers/tower_endpoint_protection.tscn",
	Data.Tower.AI_SECURITY: "res://scenes/towers/tower_ai_security.tscn"
}

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")
var explosion_scene = preload("res://scenes/bullets/explosion.tscn")
var mortar_projectile_scene = preload("res://scenes/towers/mortar_projectile.tscn")
var level_root: Node2D
var level_manager: Node
var selected_tower: Data.Tower
var current_tower: Tower
var current_placement_kind: String = ""
var tower_menu: bool = false
var next_tower_id: int = 1

var preview_initialized := false

var place_tower: bool = false:
	set(value):
		place_tower = value
		Data.is_placing_tower = value


func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager

func _ready() -> void:
	Data.cancel_tower_placement.connect(cancel_selection)

func _process(delta: float) -> void:
	var preview = _get_tower_preview()
	var place_btn = preview.get_node("PlaceTower")
	var range_indicator = preview.get_node_or_null("RangeIndicator") as Line2D
	if Data.is_tower_placeable:
		place_btn.show()
		preview.modulate = Color.WHITE
		range_indicator.default_color = Color(1, 1, 1, 0.7)
			
	else:
		place_btn.hide()
		preview.modulate = Color(1.0, 0.4, 0.4, 0.8)
		range_indicator.default_color = Color(1.0, 0.2, 0.2, 0.8)
		
		
func handle_input(event: InputEvent) -> void:
	var cell_pos = level_manager.mouse_to_map_position()
	var world_pos = level_manager.map_to_world(cell_pos)
	# Move preview only while dragging with left mouse button
	if place_tower:
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var preview = _get_tower_preview()
			if preview:
				if !preview.visible:
					preview.show()

				if !preview_initialized:
					preview.show()
					preview_initialized = true

				preview.position = world_pos
				_update_preview_buttons(cell_pos, preview)

		elif event is InputEventScreenDrag:
			var preview = _get_tower_preview()
			if preview:
				if !preview.visible:
					preview.show()

				preview.position = world_pos
				_update_preview_buttons(cell_pos, preview)
	if Input.is_action_just_pressed("exit"):
		cancel_selection()


func start_tower_placement(tower_type: Data.Tower) -> void:
	Data.cancel_sentinel_placement.emit()
	place_tower = true
	current_placement_kind = "tower"
	selected_tower = tower_type

	var preview = _get_tower_preview()
	if preview:
		preview.show()
		preview_initialized = false
		# preview.position = Vector2.ZERO
		var camera = get_tree().get_first_node_in_group("camera")
		var cameraX = camera.position.x
		var cameraY = camera.position.y
		preview.position = Vector2(cameraX, cameraY)
		var cell_pos = level_manager.world_to_map(preview.position)
		_update_preview_buttons(cell_pos, preview)
		_update_preview_range(preview)
		
		preview.texture = load(Data.TOWER_DATA[tower_type]["thumbnail"])
		preview.modulate = Color.WHITE
		preview.scale = Vector2(0.7, 0.7)
		preview.offset = Vector2(0, -53)

		
		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		place_btn.show()
		cancel_btn.show()

		if !place_btn.pressed.is_connected(confirm_current_placement):
			place_btn.pressed.connect(confirm_current_placement)

		if !cancel_btn.pressed.is_connected(cancel_current_placement):
			cancel_btn.pressed.connect(cancel_current_placement)

func cancel_selection() -> void:
	place_tower = false
	var preview = _get_tower_preview()
	if preview:
		preview.hide()
		preview.get_node("RangeIndicator").hide()

		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		place_btn.hide()
		cancel_btn.hide()
		
	current_placement_kind = ""
	tower_menu = false
	current_tower = null

	for tower in get_tree().get_nodes_in_group("Towers"):
		tower.hide_ui()
	Data.is_placing_tower = false
	
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.set_selected(false)


func create_bullet(pos, angle, bullet_enum, damage, tower_type, tower_id := -1, target = null):
	if bullet_enum == Data.Bullet.SINGLE:
		var bullet = bullet_scene.instantiate()
		bullet.setup(pos, angle, bullet_enum, damage, tower_type, tower_id, target)
		_get_bullet_parent().add_child(bullet)
		
	if bullet_enum == Data.Bullet.FIRE:
		# Get the tower's range from data
		var tower_range = 100 # default fallback
		if tower_type != null:
			var tower_data = Data.TOWER_DATA.get(tower_type, null)
			if tower_data:
				tower_range = tower_data.get("range", 100)
		
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if pos.distance_to(enemy.global_position) < tower_range:
				# IDPS can hit invisible enemies and disables their invisibility
				if tower_type == Data.Tower.IDPS and enemy.invisible:
					enemy.set_invisible(false)

				var enemy_damage = damage
				if tower_type == Data.Tower.ACCESS_CONTROL_SYSTEM and enemy.enemy_type_stats == Data.Enemy.INSIDERTHREAT:
					var acs_data = Data.TOWER_DATA[Data.Tower.ACCESS_CONTROL_SYSTEM]
					var damage_multiplier = 1.5 if acs_data.get("tier2abilityunlocked", false) else 1.25
					enemy_damage = int(round(damage * damage_multiplier))
				enemy.hit(enemy_damage, tower_id)
	
				if tower_type == Data.Tower.ENDPOINT_PROTECTION:
					enemy.toggle_ep_particles()
	
	var enemies = get_tree().get_first_node_in_group("Enemies")
	enemies.emit_hit_particles(angle) # to set the angle of the hit particles

func tower_selection(tower: Tower) -> void:
	if current_tower and current_tower != tower:
		current_tower.hide_ui()

	current_tower = tower
	tower_menu = true

	tower.show_range()


func _try_place_current_building(cell_pos: Vector2i, world_pos: Vector2) -> void:
	if current_placement_kind == "tower":
		_try_place_tower(cell_pos, world_pos)


func _try_place_tower(cell_pos: Vector2i, world_pos: Vector2) -> void:
	var layer = level_manager.get_build_layer()
	var asset_layer = level_manager.get_asset_layer()
	if layer == null:
		return
	if asset_layer == null:
		return

	var tile_data = layer.get_cell_tile_data(cell_pos) as TileData
	var asset_tile_data = asset_layer.get_cell_tile_data(cell_pos) as TileData

	if tile_data == null or not tile_data.get_custom_data("Usable"):
		return

	if not asset_tile_data == null:
		if not asset_tile_data.get_custom_data("Usable") == null:
			if not asset_tile_data.get_custom_data("Usable"):
				return

	if not Data.is_tower_placeable:
		return

	var cost = Data.TOWER_DATA[selected_tower]["cost"]
	var using_free: bool = Data.free_towers.get(selected_tower, 0) > 0
	var systemload = Data.TOWER_DATA[selected_tower]["server_load"]
	
	if Data.currentserverload >= Data.maxserverload:
		place_tower = false
		for card in get_tree().get_nodes_in_group("TowerCard"):
			card.set_selected(false)
		return
		
	if !using_free:
		if not Data.is_unli_money and Data.money < cost:
			place_tower = false
			for card in get_tree().get_nodes_in_group("TowerCard"):
				card.set_selected(false)
			return


	var tower = load(tower_scenes[selected_tower]).instantiate()
	tower.tower_id = next_tower_id
	next_tower_id += 1
	tower.position = world_pos
	tower.setup(selected_tower)
	tower.cell_pos = cell_pos
	tower.connect("shoot", create_bullet)
	tower.connect("shoot_mortar", create_mortar_projectile)
	tower.connect("select", tower_selection)
	tower.connect("removed", _on_tower_removed)
	_get_tower_parent().add_child(tower)
	EnemyTower.register_tower(tower.tower_id, selected_tower)
	
	if selected_tower == Data.Tower.BACKUP_SERVER:
		Data.backup_server_placed = true
	
	place_tower = false
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.set_selected(false)
	var preview = _get_tower_preview()
	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview.get_node("RangeIndicator").hide()
		preview_initialized = false
		preview.position = Vector2.ZERO
		preview.get_node("PlaceTower").hide()
		preview.get_node("CancelPlace").hide()
	if using_free:
		var remaining: int = Data.free_towers.get(selected_tower, 0)

		if remaining > 1:
			Data.free_towers[selected_tower] = remaining - 1
		else:
			Data.free_towers.erase(selected_tower)
	else:
		if !Data.is_unli_money:
			Data.money -= cost

		# Only buying permanently increases ownership
		Data.owned_towers[selected_tower] = Data.owned_towers.get(selected_tower, 0) + 1
	Data.currentserverload += systemload
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()
		
		if Data.active_adware > 0:
			ui._schedule_next_ad()

		if Data.active_ransomware > 0:
			ui._schedule_next_ransomware()

	if Data.TOWER_DATA[selected_tower]["name"] == "Spam Filter" and !GameDialogueManager.is_introduction_spam_filter and !Data.is_sandbox and (Data.current_wave == 0 or Data.current_wave == 1):
		GameDialogueManager.show_dialogue_spam_filter()

	if ((Data.maxserverload - Data.currentserverload) < 15 or Data.money < 30) and !GameDialogueManager.is_prep and !Data.is_sandbox and Data.current_wave == 4:
		GameDialogueManager.show_dialogue_preparation_end()
	

func _on_tower_removed(cell_pos: Vector2i) -> void:
	if current_tower and current_tower.cell_pos == cell_pos:
		current_tower = null


func _get_tower_parent() -> Node:
	return level_root.get_node("Towers")


func _get_bullet_parent() -> Node:
	return level_root.get_node("Bullets")


func _get_tower_preview() -> Node2D:
	return level_root.get_node_or_null("BG/TowerPreview") as Node2D


func create_mortar_projectile(start_pos, target_enemy, damage, tower_type, tower_id):
	var projectile = mortar_projectile_scene.instantiate()
	projectile.setup(start_pos, target_enemy, damage, tower_type, tower_id)
	_get_bullet_parent().add_child(projectile)
	
func confirm_current_placement() -> void:
	if !place_tower:
		return

	var preview = _get_tower_preview()
	if preview == null:
		return

	var world_pos = preview.position
	var cell_pos = level_manager.world_to_map(world_pos)

	_try_place_current_building(cell_pos, world_pos)

func cancel_current_placement() -> void:
	var preview = _get_tower_preview()

	if preview:
		preview.hide()
		preview.modulate = Color.WHITE
		preview_initialized = false
		preview.position = Vector2.ZERO
		var place_btn = preview.get_node("PlaceTower")
		var cancel_btn = preview.get_node("CancelPlace")

		place_btn.hide()
		cancel_btn.hide()

	cancel_selection()

func _update_preview_buttons(cell_pos: Vector2i, preview: Node2D) -> void:
	var place_btn = preview.get_node("PlaceTower")

	var layer = level_manager.get_build_layer()
	var asset_layer = level_manager.get_asset_layer()

	var valid := true


	var tile_data = layer.get_cell_tile_data(cell_pos)
	if tile_data == null or !tile_data.get_custom_data("Usable"):
		valid = false

	if asset_layer:
		var asset_tile = asset_layer.get_cell_tile_data(cell_pos)
		if asset_tile != null:
			if asset_tile.get_custom_data("Usable") != null and !asset_tile.get_custom_data("Usable"):
				valid = false

	if !Data.is_tower_placeable:
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
		
func _update_preview_range(preview: Node2D) -> void:
	var range_indicator = preview.get_node_or_null("RangeIndicator") as Line2D

	if range_indicator == null:
		return

	var tower_data = Data.TOWER_DATA.get(selected_tower, {})
	var tower_range: float = float(tower_data.get("range", 0))

	if tower_range <= 0:
		range_indicator.visible = false
		return

	var points := PackedVector2Array()
	var segments := 100

	for i in range(segments + 1):
		var angle = TAU * i / segments
		points.append(Vector2(cos(angle), sin(angle)) * tower_range)

	range_indicator.points = points

	# Counteract TowerPreview's 0.7 scale
	range_indicator.scale = Vector2.ONE / preview.scale

	range_indicator.visible = true
