extends Node

signal level_completed
signal next_map

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var level_root: Node2D
var level_manager: Node
var wave_active := false
var spawning_wave := false


func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func update_wave_state() -> void:
	var ui = get_tree().get_first_node_in_group("UI")

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if wave_active and not spawning_wave and enemies.size() == 0:
		wave_active = false
		if not wave_active and Data.current_wave % 10 == 0:
			if ui:
				ui.disable_auto()
			level_completed.emit()
			next_map.emit()
	
	if not wave_active and not spawning_wave and enemies.size() == 0:
		if ui and ui.is_auto_enabled():
			start_wave()


func start_wave() -> void:
	if wave_active or spawning_wave:
		return

	var data = _random_wave_size()
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.update_wave_label()

	Data.current_wave += 1


	if Data.current_wave % 5 == 0:
		Data.checkpoint_wave = Data.current_wave

	wave_active = true
	spawning_wave = true

	for enemy_enum in data:
		for i in range(data[enemy_enum]):
			_spawn_enemy(enemy_enum)
			await get_tree().create_timer(0.5).timeout

	spawning_wave = false


func spawn_sandbox_enemy(enemy_enum: Data.Enemy) -> void:
	wave_active = true
	_spawn_enemy(enemy_enum)


func _spawn_enemy(enemy_enum: Data.Enemy) -> void:
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	enemy.setup(path_follow, enemy_enum)
	path_follow.add_child(enemy)
	_get_path().add_child(path_follow)


func _random_wave_size() -> Dictionary:
	var difficulty = Data.current_wave
	var total_enemies = randi_range(5 + difficulty * 2, 8 + difficulty * 3)
	var wave: Dictionary = {}

	for i in range(total_enemies):
		var enemy_type = _choose_random_enemy_type(difficulty)
		wave[enemy_type] = wave.get(enemy_type, 0) + 1

	return wave


func _choose_random_enemy_type(difficulty: int) -> Data.Enemy:
	var default_chance = clamp(70 - difficulty * 4, 15, 70)
	var fast_chance = clamp(20 + difficulty * 3, 15, 40)
	var strong_chance = clamp(8 + difficulty * 2, 10, 30)

	var roll = randi() % 100
	if roll < default_chance:
		return Data.Enemy.DEFAULT
	elif roll < default_chance + fast_chance:
		return Data.Enemy.FAST
	elif roll < default_chance + fast_chance + strong_chance:
		return Data.Enemy.STRONG

	return Data.Enemy.BIG


func _get_path() -> Path2D:
	return level_root.get_node("Path2D")