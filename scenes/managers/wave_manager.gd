extends Node

signal level_completed
signal next_map

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var level_root: Node2D
var level_manager: Node
var wave_active: bool = false
var spawning_wave: bool = false


func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func update_wave_state() -> void:
	var ui = get_tree().get_first_node_in_group("UI")

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if wave_active and not spawning_wave and enemies.size() == 0:
		wave_active = false
		if not wave_active and Data.current_wave % 10 == 0:
			if !Data.is_sandbox:
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

	match Data.current_wave:
		6:
			$'../WeatherEffects/DustParticles'.visible = false
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = true
		11:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
		21:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
		31:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false

		41:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false
		51:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false


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
	var path: Path2D = _choose_path_for_spawn()
	if path:
		path.add_child(path_follow)


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
	var fast_chance = clamp(70 - difficulty * 4, 15, 70)
	var big_chance = clamp(60 + difficulty * 3, 15, 60)
	var strong_chance = clamp(50 + difficulty * 2, 10, 50)
	var extreme_chance = clamp(40 + difficulty * 2, 10, 40)
	var worm_chance = clamp(40 + difficulty * 2, 10, 40)

	var roll = randi() % 100
	if roll < default_chance:
		return Data.Enemy.DEFAULT
	elif roll < default_chance + big_chance:
		return Data.Enemy.ADWARE
	elif roll < default_chance + fast_chance + strong_chance:
		return Data.Enemy.SPYWARE
	elif roll < default_chance + fast_chance + strong_chance + worm_chance:
		return Data.Enemy.CREDS
	elif roll < default_chance + fast_chance + strong_chance + extreme_chance + worm_chance:
		return Data.Enemy.BOTNET
	return Data.Enemy.WORM


func _get_paths() -> Array[Path2D]:
	var paths: Array[Path2D] = []
	
	for child in level_root.get_children():
		if child is Path2D:
			paths.append(child)
	return paths

func _choose_path_for_spawn() -> Path2D:
	var paths: Array = _get_paths()
	return paths[randi() % paths.size()]
