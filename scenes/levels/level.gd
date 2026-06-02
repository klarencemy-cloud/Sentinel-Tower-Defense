extends Node2D

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")
var bullet_scene = preload("res://scenes/bullets/bullet.tscn")
var explosion_scene = preload("res://scenes/bullets/explosion.tscn")
var place_tower: bool:
	set(value):
		place_tower = value
		$BG/TowerPreview.visible = value
var selected_tower: Data.Tower
var current_tower: Tower
var tower_menu: bool
var tower_scenes = {
	Data.Tower.BASIC: "res://scenes/towers/tower_basic.tscn",
	Data.Tower.BLAST: "res://scenes/towers/tower_blaster.tscn",
	Data.Tower.MORTAR: "res://scenes/towers/tower_mortar.tscn",}
var used_cells: Array[Vector2i]

func _ready() -> void:
	RenderingServer.set_default_clear_color('dff6f5')


func _input(event: InputEvent) -> void:
	var raw_pos = get_local_mouse_position()
	var pos = Vector2i(raw_pos.x / 16, raw_pos.y / 16)
	
	if event is InputEventMouseButton and event.button_mask == 1 and place_tower:
		var tile_data = $BG/TileMapLayer.get_cell_tile_data(pos) as TileData
		if event.button_index == 1 and pos not in used_cells and tile_data is TileData and tile_data.get_custom_data('Usable'):
			used_cells.append(pos)
			var tower = load(tower_scenes[selected_tower]).instantiate()
			tower.position = pos * 16 + Vector2i(8,8)
			tower.setup(selected_tower)
			tower.connect('shoot', create_bullet)
			tower.connect('select', tower_selection)
			$Towers.add_child(tower)
			place_tower = false
			Data.money -= Data.TOWER_DATA[selected_tower]['cost']
	if event is InputEventMouseButton and event.button_mask == 1 and current_tower:
		if current_tower.type == Data.Tower.MORTAR:
			current_tower.finish_placing()
			current_tower = null
	
	if event is InputEventMouseMotion and tower_menu:
		if current_tower and current_tower.type == Data.Tower.MORTAR:
			current_tower.crosshair_pos_update(pos * 16 + Vector2i(8,8))
	if event is InputEventMouseMotion and place_tower:
		var tower_pos = pos * 16 + Vector2i(8,8)
		$BG/TowerPreview.position = tower_pos
	
	if Input.is_action_just_pressed("exit"):
		place_tower = false
		tower_menu = false
		current_tower = null
		$UI.hide_cards()
		for tower in get_tree().get_nodes_in_group('Towers'):
			tower.hide_ui()


func create_bullet(pos: Vector2, angle: float, bullet_enum: Data.Bullet):
	if bullet_enum == Data.Bullet.SINGLE:
		var bullet = bullet_scene.instantiate()
		bullet.setup(pos, angle, bullet_enum)
		$Bullets.add_child(bullet)
	if bullet_enum == Data.Bullet.FIRE:
		for enemy in get_tree().get_nodes_in_group('Enemies'):
			if pos.distance_to(enemy.global_position) < 100:
				enemy.hit()
	if bullet_enum == Data.Bullet.MORTAR_EXPLOSION:
		var explosion = explosion_scene.instantiate()
		explosion.setup(pos)
		$Bullets.add_child(explosion)


func tower_selection(tower: Tower):
	current_tower = tower
	tower_menu = true
	if tower.type == Data.Tower.MORTAR:
		tower.show_crosshair()


func _on_ui_place_tower(tower_type: Data.Tower) -> void:
	place_tower = true
	selected_tower = tower_type
	$BG/TowerPreview.texture = load(Data.TOWER_DATA[tower_type]['thumbnail'])


func _on_ui_start_wave() -> void:
	var data = Data.ENEMY_WAVES[Data.current_wave]
	Data.current_wave += 1
	# {enum: num}
	for enemy_enum in data:
		for i in data[enemy_enum]:
			var path_follow = PathFollow2D.new()
			var enemy = enemy_scene.instantiate()
			enemy.setup(path_follow, enemy_enum)
			path_follow.add_child(enemy)
			$Path2D.add_child(path_follow)
			await get_tree().create_timer(0.5).timeout
