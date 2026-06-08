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
var wave_active: bool = false
var spawning_wave: bool = false
var health = Data.health


func _ready() -> void:
	randomize()
	RenderingServer.set_default_clear_color('dff6f5')

	var ui = get_tree().get_first_node_in_group('UI')
	if ui:
		ui.spawn_enemy.connect(_on_ui_spawn_sandbox_enemy)
	

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group('Enemies')
	if wave_active and not spawning_wave and enemies.size() == 0:
		wave_active = false

	if not wave_active and not spawning_wave and enemies.size() == 0:
		var ui = get_tree().get_first_node_in_group('UI')
		if ui and ui.is_auto_enabled():
			_on_ui_start_wave()


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
	if current_tower and current_tower != tower:
		current_tower.hide_ui()

	current_tower = tower
	tower_menu = true
	if tower.type == Data.Tower.MORTAR:
		tower.show_crosshair()
	tower.show_range()


func _on_ui_place_tower(tower_type: Data.Tower) -> void:
	place_tower = true
	selected_tower = tower_type
	$BG/TowerPreview.texture = load(Data.TOWER_DATA[tower_type]['thumbnail'])


func _on_ui_start_wave() -> void:
	if wave_active or spawning_wave == true:
		return
	var data = _random_wave_size()
	get_tree().get_first_node_in_group('UI').update_wave_label()
	Data.current_wave += 1
	if Data.current_wave % 5 == 0:
		Data.checkpoint_wave = Data.current_wave
	wave_active = true
	spawning_wave = true
	for enemy_enum in data:
		for i in data[enemy_enum]:
			var path_follow = PathFollow2D.new()
			var enemy = enemy_scene.instantiate()
			enemy.setup(path_follow, enemy_enum)
			path_follow.add_child(enemy)
			$Path2D.add_child(path_follow)
			await get_tree().create_timer(0.5).timeout
	spawning_wave = false


func _random_wave_size() -> Dictionary:
	var difficulty = Data.current_wave
	var total_enemies = randi_range(5 + difficulty * 2, 8 + difficulty * 3)
	var wave: Dictionary = {}
	for i in total_enemies:
		var enemy_type = _choose_random_enemy_type(difficulty)
		wave[enemy_type] = wave.get(enemy_type, 0) + 1
	return wave


func _choose_random_enemy_type(difficulty: int) -> Data.Enemy:
	var default_chance = clamp(70 - difficulty * 4, 15, 70)
	var fast_chance = clamp(20 + difficulty * 3, 15, 40)
	var strong_chance = clamp(8 + difficulty * 2, 10, 30)
	var big_chance = 100 - default_chance - fast_chance - strong_chance

	var roll = randi() % 100
	if roll < default_chance:
		return Data.Enemy.DEFAULT
	elif roll < default_chance + fast_chance:
		return Data.Enemy.FAST
	elif roll < default_chance + fast_chance + strong_chance:
		return Data.Enemy.STRONG
	return Data.Enemy.BIG

func _on_ui_spawn_sandbox_enemy(enemy_enum: Data.Enemy) -> void:
	wave_active = true
	
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()
	
	
	enemy.setup(path_follow, enemy_enum)
	path_follow.add_child(enemy)
	$Path2D.add_child(path_follow)
