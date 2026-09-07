extends Node

signal level_completed
signal next_map

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var level_root: Control
var level_manager: Node
var wave_active: bool = false
var spawning_wave: bool = false

func _ready() -> void:
	add_to_group("WaveManager")
	change_weather()
func setup(root: Control, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func update_wave_state() -> void:
	var ui = get_tree().get_first_node_in_group("UI")

	var enemies = get_tree().get_nodes_in_group("Enemies")

	if wave_active and not spawning_wave and enemies.size() == 0:
		wave_active = false

		if Data.current_wave > 0 and Data.current_wave % 5 == 0 and Data.checkpoint_wave < Data.current_wave:
			Data.checkpoint_wave = Data.current_wave

		if Data.current_wave % 10 == 0:
			if !Data.is_sandbox and !Data.is_vmmode:
				if ui:
					ui.disable_auto()
				level_completed.emit()
				next_map.emit()
			return

	if not wave_active and not spawning_wave and enemies.size() == 0:
		if Data.wave_started:
			Data.wave_started = false
			Data.current_wave += 1
			Data.update_wave_unlocks()

			if !Data.is_sandbox and !Data.is_vmmode:
				Save.save_game()
			if ui:
				ui.update_wave_label()

		#for dialogue trigger
		if Data.current_wave == 2 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_defeat_spam:
			GameDialogueManager.is_defeat_spam = true
			GameDialogueManager.show_dialogue_spam_defeat()

		if Data.current_wave == 3 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_wave2_defeated:
			GameDialogueManager.is_wave2_defeated = true
			GameDialogueManager.play_scene("2nd_scene")

		if Data.current_wave == 5 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_firewall_shown:
			GameDialogueManager.show_dialogue_firewall()

		if Data.current_wave == 7 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_server2:
			GameDialogueManager.show_dialogue_server_upgrade_2()

		if Data.current_wave == 32 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_ep_unlocked:
			GameDialogueManager.is_ep_unlocked = true
			GameDialogueManager.unlock_towers(9, "epprotection")
		
		if Data.current_wave == 36 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_sandbox_unlocked:
			GameDialogueManager.is_sandbox_unlocked = true
			GameDialogueManager.unlock_towers(10, "sandbox")

		if Data.current_wave == 38 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_strange_discovery_shown:
			GameDialogueManager.show_dialogue_level4_strange_discovery()

		if Data.current_wave == 47 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_level5_hidden_archive_shown:
			GameDialogueManager.show_dialogue_level5_hidden_archive()

		if Data.current_wave == 49 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_level5_hidden_archive2_shown:
			GameDialogueManager.show_dialogue_level5_hidden_archive2()

		if Data.current_wave == 50 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_level5_final_fragment_shown:
			GameDialogueManager.show_dialogue_level5_final_fragment()

		# if Data.current_wave == 52 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_story_ends:
		# 	GameDialogueManager.show_dialogue_story_ends()

		if ui and ui.is_auto_enabled():
			start_wave()


func start_wave() -> void:
	if Data.is_vmmode:
		return # VM mode own spawning, independent of Wave.WAVE_DATA
	if wave_active or spawning_wave:
		return
	Data.clear_notpetya_enemy_speed_effect()
	Data.wave_started = true


	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.update_wave_label()
	if Data.current_wave == 6 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_1_shown:
			GameDialogueManager.show_dialogue_question1()
	if Data.current_wave == 8 and !Data.is_sandbox and !GameDialogueManager.is_adware_shown:
		GameDialogueManager.show_dialogue_adware()
	if Data.current_wave == 10 and !Data.is_sandbox and !GameDialogueManager.is_boss1_shown:
		GameDialogueManager.show_dialogue_boss1()
	if Data.current_wave == 11 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_2_shown:
			GameDialogueManager.show_dialogue_question2()
	if Data.current_wave == 12 and !Data.is_sandbox and !GameDialogueManager.is_level2_worm_shown:
		GameDialogueManager.show_dialogue_level2_worm()
	if Data.current_wave == 15 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_3_shown:
			GameDialogueManager.show_dialogue_question3()
	if Data.current_wave == 16 and !Data.is_sandbox and !GameDialogueManager.is_level2_spyware_shown:
		GameDialogueManager.show_dialogue_level2_spyware()
	if Data.current_wave == 19 and !Data.is_sandbox and !GameDialogueManager.is_level2_botnet_shown:
		GameDialogueManager.show_dialogue_level2_botnet()
	if Data.current_wave == 20 and !Data.is_sandbox and !GameDialogueManager.is_level2_boss2_shown:
		GameDialogueManager.show_dialogue_level2_boss2()
	if Data.current_wave == 21 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_4_shown:
			GameDialogueManager.show_dialogue_question4()
			GameDialogueManager.is_question_4_shown = true
	if Data.current_wave == 22 and !Data.is_sandbox and !GameDialogueManager.is_level3_credential_shown:
		GameDialogueManager.show_dialogue_level3_credential()
	if Data.current_wave == 24 and !Data.is_sandbox and !GameDialogueManager.is_level3_trojan_horse_shown:
		GameDialogueManager.show_dialogue_level3_trojan_horse()
	if Data.current_wave == 25 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_5_shown:
			GameDialogueManager.show_dialogue_question5()
	if Data.current_wave == 28 and !Data.is_sandbox and !GameDialogueManager.is_quiz1_shown:
		GameDialogueManager.show_dialogue_level3_quiz1()
	if Data.current_wave == 30 and !Data.is_sandbox and !GameDialogueManager.is_boss3_shown:
		GameDialogueManager.show_dialogue_level3_boss3()
	if Data.current_wave == 31 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_6_shown:
			GameDialogueManager.show_dialogue_question6()
	if Data.current_wave == 32 and !Data.is_sandbox and !GameDialogueManager.is_level4_rootkit_shown:
		GameDialogueManager.show_dialogue_level4_rootkit()
	if Data.current_wave == 34 and !Data.is_sandbox and !GameDialogueManager.is_level4_sql_shown:
		GameDialogueManager.show_dialogue_level4_sql()
	if Data.current_wave == 35 and !Data.is_sandbox and !GameDialogueManager.is_level4_quiz2_shown:
		GameDialogueManager.show_dialogue_level4_quiz2()
	if Data.current_wave == 36 and !Data.is_sandbox and !GameDialogueManager.is_level4_ddos_shown:
		GameDialogueManager.show_dialogue_level4_ddos()
	if Data.current_wave == 37 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_7_shown:
			GameDialogueManager.show_dialogue_question7()
	if Data.current_wave == 38 and !Data.is_sandbox and !GameDialogueManager.is_level4_ransomware_shown:
		GameDialogueManager.show_dialogue_level4_ransomware()
	if Data.current_wave == 40 and !Data.is_sandbox and !GameDialogueManager.is_boss4_shown:
		GameDialogueManager.show_dialogue_level4_boss4()
	if Data.current_wave == 41 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_8_shown:
			GameDialogueManager.show_dialogue_question8()
	if Data.current_wave == 43 and !Data.is_sandbox and !GameDialogueManager.is_zero_day_shown:
		GameDialogueManager.show_dialogue_level5_zero_day()
	if Data.current_wave == 45 and !Data.is_sandbox and !GameDialogueManager.is_level5_quiz3_shown:
		GameDialogueManager.show_dialogue_level5_quiz3()
	if Data.current_wave == 46 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_question_9_shown:
			GameDialogueManager.show_dialogue_question9()
	if Data.current_wave == 50 and !Data.is_sandbox and !GameDialogueManager.is_level5_boss5_shown:
		GameDialogueManager.show_dialogue_level5_boss5()
	if Data.current_wave == 51 and !Data.is_sandbox and !GameDialogueManager.is_level6_boss6_shown:
		GameDialogueManager.show_dialogue_level6_boss6()

	change_weather()

	wave_active = true
	spawning_wave = true

	# FETCHS WAVE DATA FROM wave_data.gd(Global)
	var wave_data = Wave.WAVE_DATA.get(Data.current_wave, null)

	if wave_data != null:
		await _spawn_predefined_wave(wave_data)
	spawning_wave = false


# Predefined wave spawning

func _spawn_predefined_wave(wave_data: Dictionary) -> void:
	var paths: Array[Path2D] = _get_paths()

	var enemies_data: Dictionary = wave_data["enemies"]

	for enemy_enum in enemies_data.keys():
		var per_path_counts: Array = enemies_data[enemy_enum]

		for path_index in range(per_path_counts.size()):
			var count: int = per_path_counts[path_index]

			if path_index >= paths.size():
				push_warning("Wave %d: path index %d out of bounds (only %d paths)" % [Data.current_wave, path_index, paths.size()])
				continue

			var path: Path2D = paths[path_index]

			for i in range(count):
				_spawn_enemy_on_path(enemy_enum, path)
				await get_tree().create_timer(0.5, false).timeout

func change_weather() -> void:
	match Data.current_wave:
		6:
			$'../WeatherEffects/DustParticles'.visible = false
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = true
			UISound.stop_rain_bg()
		11:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
			UISound.stop_rain_bg()
		21:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
			UISound.stop_rain_bg()
		31:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false
			UISound.stop_rain_bg()

		41:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false
			UISound.play_rain_bg()
		51:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false
			UISound.play_rain_bg()

func _spawn_enemy_on_path(enemy_enum: Data.Enemy, path: Path2D, lane_offset: float = 0.0) -> Node:
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	path.add_child(path_follow)
	path_follow.add_child(enemy)

	enemy.lane_offset = lane_offset
	enemy.setup(path_follow, enemy_enum)

	path.move_child(path_follow, 0)

	return enemy

func spawn_sandbox_enemy(enemy_enum: Data.Enemy, lane_offset: float = 0.0) -> Node:
	wave_active = true
	var paths = _get_paths()
	if paths.size() > 0:
		var path = paths[randi() % paths.size()]
		return _spawn_enemy_on_path(enemy_enum, path, lane_offset)
	return null


const LANE_GROUP_SPAWN_STAGGER: float = 0.3

func spawn_enemy_lane_group(enemy_enums: Array, path: Path2D = null, lane_offsets: Array = [], spawn_stagger: float = LANE_GROUP_SPAWN_STAGGER, on_enemy_spawned: Callable = Callable()) -> Array:
	var spawned: Array = []
	if enemy_enums.is_empty():
		return spawned

	if path == null:
		var paths := _get_paths()
		if paths.is_empty():
			return spawned
		path = paths[randi() % paths.size()]

	wave_active = true

	for i in range(enemy_enums.size()):
		var offset: float = 0.0
		if i < lane_offsets.size():
			offset = float(lane_offsets[i])
		var enemy := _spawn_enemy_on_path(enemy_enums[i], path, offset)
		if on_enemy_spawned.is_valid():
			on_enemy_spawned.call(enemy)
		spawned.append(enemy)
		if spawn_stagger > 0.0 and i < enemy_enums.size() - 1:
			await get_tree().create_timer(spawn_stagger, false).timeout

	return spawned


func _get_paths() -> Array[Path2D]:
	var paths: Array[Path2D] = []

	for child in level_root.get_children():
		if child is Path2D:
			paths.append(child)
	return paths


func spawn_worm_clone(path: Path2D, progress: float):
	var path_follow = PathFollow2D.new()
	path_follow.progress = progress

	var enemy = enemy_scene.instantiate()
	path.add_child(path_follow)
	path_follow.add_child(enemy)

	enemy.setup(path_follow, Data.Enemy.WORM)
	enemy.can_clone = false

	path.move_child(path_follow, 0)

func spawn_ddos_clones(path: Path2D, progress: float):
	var offsets = [-40, 0, 40]

	for offset in offsets:
		var path_follow = PathFollow2D.new()
		path_follow.progress = max(progress + offset, 0)

		var enemy = enemy_scene.instantiate()
		path_follow.add_child(enemy)
		path.add_child(path_follow)
		enemy.setup(path_follow, Data.Enemy.DDOS)

		enemy.scale = Vector2(0.75, 0.75) # clone is 25% smaller
		enemy.is_ddos_clone = true

		var hp = int(Data.ENEMY_DATA[Data.Enemy.DDOS]["health"] * 0.35)
		enemy.health = hp
		enemy.get_node("hpbar").max_value = hp
		enemy.get_node("hpbar").value = hp
		path.move_child(path_follow, 0)
	

func spawn_enemy_on_path(enemy_enum: Data.Enemy, path: Path2D):
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	path.add_child(path_follow)
	path_follow.add_child(enemy)

	enemy.setup(path_follow, enemy_enum)

	path.move_child(path_follow, 0)

func spawn_boss_viruses():
	var paths: Array[Path2D] = []

	if level_root:
		for child in level_root.get_children():
			if child is Path2D:
				paths.append(child)
	else:
		for child in get_tree().current_scene.get_children():
			if child is Path2D:
				paths.append(child)

	for path in paths:
		spawn_enemy_on_path(Data.Enemy.VIRUS, path)

func spawn_boss_botnets():
	var paths: Array[Path2D] = []

	if level_root:
		for child in level_root.get_children():
			if child is Path2D:
				paths.append(child)
	else:
		for child in get_tree().current_scene.get_children():
			if child is Path2D:
				paths.append(child)

	for path in paths:
		spawn_enemy_on_path(Data.Enemy.BOTNET, path)

func spawn_boss5_wave():
	var enemies = [
		Data.Enemy.DEFAULT,
		Data.Enemy.VIRUS,
		Data.Enemy.ADWARE,
		Data.Enemy.SPYWARE,
		Data.Enemy.TROJAN,
		Data.Enemy.CREDS,
		Data.Enemy.BOTNET,
		Data.Enemy.WORM,
		Data.Enemy.INSIDERTHREAT,
		Data.Enemy.ROOTKIT,
		Data.Enemy.SQL,
		Data.Enemy.DDOS,
		Data.Enemy.RANSOMWARE,
		Data.Enemy.ZERO
	]

	var paths = _get_paths()

	for path in paths:
		var random_enemy = enemies.pick_random()
		spawn_enemy_on_path(random_enemy, path)
	
func spawn_boss6_hologram_bosses() -> void:
	var paths: Array[Path2D] = _get_paths()

	if paths.is_empty():
		return

	var available_bosses: Array[Data.Enemy] = []

	var boss_types = [
		Data.Enemy.BOSS1,
		Data.Enemy.BOSS2,
		Data.Enemy.BOSS3,
		Data.Enemy.BOSS4,
		Data.Enemy.BOSS5
	]

	# Find which Boss1-5 types are already alive
	for boss_type in boss_types:
		var already_alive := false

		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if not is_instance_valid(enemy):
				continue

			if enemy.is_queued_for_deletion():
				continue

			if enemy.dead:
				continue

			if enemy.enemy_type_stats == boss_type:
				already_alive = true
				break

		if not already_alive:
			available_bosses.append(boss_type)

	# All Boss1-5 are currently alive
	if available_bosses.is_empty():
		print("Boss6: No boss to spawn")
		return

	# Shuffle available bosses
	available_bosses.shuffle()

	# Spawn one boss on each path.
	var bosses_to_spawn: Array[Data.Enemy] = []

	for i in range(min(paths.size(), available_bosses.size())):
		bosses_to_spawn.append(available_bosses[i])

	for i in range(bosses_to_spawn.size()):
		var boss_type: Data.Enemy = bosses_to_spawn[i]
		var path: Path2D = paths[i]

		_spawn_boss6_hologram_on_path(boss_type, path)
		
func _spawn_boss6_hologram_on_path(enemy_enum: Data.Enemy, path: Path2D) -> Node:
	var path_follow := PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	path.add_child(path_follow)
	path_follow.add_child(enemy)

	enemy.is_boss6_spawned = true
	enemy.is_hologram = true

	enemy.setup(path_follow, enemy_enum)

	# 50% HP
	var hologram_hp := int(enemy.health * 0.5)

	enemy.health = hologram_hp
	enemy.get_node("hpbar").max_value = hologram_hp
	enemy.get_node("hpbar").value = hologram_hp
	enemy.get_node("hpbar").visible = true

	path.move_child(path_follow, 0)

	return enemy

func spawn_boss6_resurrected_enemy(enemy_enum: Data.Enemy, path: Path2D) -> Node:
	if not is_instance_valid(path):
		return null

	var path_follow := PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	path.add_child(path_follow)
	path_follow.add_child(enemy)

	enemy.is_resurrected = true
	enemy.is_hologram = true

	# Start at the beginning of the path
	path_follow.progress = 0.0

	enemy.setup(path_follow, enemy_enum)

	# 50% of the enemy's wave-scaled HP
	var resurrected_hp := int(enemy.health * 0.5)

	enemy.health = resurrected_hp
	enemy.get_node("hpbar").max_value = resurrected_hp
	enemy.get_node("hpbar").value = resurrected_hp
	enemy.get_node("hpbar").visible = true

	path.move_child(path_follow, 0)

	return enemy
