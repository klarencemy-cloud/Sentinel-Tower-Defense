extends Node

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1

func _ready() -> void:
	add_to_group("save")
	_load_game()

func save_game() -> void:
	if Data.is_vmmode:
		return 
	print("========== SAVE GAME ==========")
	print("SAVE LOCATION: ", ProjectSettings.globalize_path(SAVE_PATH))
	print("Sandbox: ", Data.is_sandbox)
	print("Current level: ", Data.current_level_index)
	print("Towers found: ", get_tree().get_nodes_in_group("Towers").size())
	print("Sentinels found: ", get_tree().get_nodes_in_group("Sentinels").size())
	print("Abilities found: ", get_tree().get_nodes_in_group("Abilities").size())
	
	if !Data.is_sandbox:
		var tower_upgrades := {}
		for tower_enum in Data.Tower.values():
			var tower_data: Dictionary = Data.TOWER_DATA[tower_enum]
			tower_upgrades[str(tower_enum)] = {
				"levels": [
					tower_data.get("upgrade1level", 0), tower_data.get("upgrade2level", 0),
					tower_data.get("upgrade3level", 0), tower_data.get("upgrade4level", 0),
					tower_data.get("upgrade5level", 0), tower_data.get("upgrade6level", 0),
				],
				"stats": {
					"damage": tower_data.get("damage", 0), "reload_time": tower_data.get("reload_time", 0),
					"range": tower_data.get("range", 0), "crit rate": tower_data.get("crit rate", 0),
					"crit damage": tower_data.get("crit damage", 0), "explosion_radius": tower_data.get("explosion_radius", 0),
				}
			}
		var placed_towers: Array = []

		for tower in get_tree().get_nodes_in_group("Towers"):
			if tower is Tower:
				var tower_id = tower.tower_id
				var damage = EnemyTower.tower_damage.get(tower_id, 0)

				placed_towers.append({
					"type": int(tower.type),
					"cell_pos": [tower.cell_pos.x, tower.cell_pos.y],
					"damage": damage
				})
		# print(placed_towers)
		# print(Data.saved_tower_placements)
		var placed_sentinels: Array = []

		for sentinel in get_tree().get_nodes_in_group("Sentinels"):
			if sentinel.has_meta("sentinel_type"):
				placed_sentinels.append({
					"type": int(sentinel.get_meta("sentinel_type")),
					"cell_pos": [sentinel.cell_pos.x, sentinel.cell_pos.y]
				})

		var placed_abilities: Array = []

		for ability in get_tree().get_nodes_in_group("Abilities"):
			placed_abilities.append({
				"type": "firewall",
				"position": [ability.position.x, ability.position.y]
			})

		var sentinel_unlocks := {}

		for sentinel_enum in Data.Sentinel.values():
			var sentinel_data: Dictionary = Data.SENTINEL_DATA[sentinel_enum]
			sentinel_unlocks[str(sentinel_enum)] = sentinel_data.get("isUnlocked", false)
			
		var tower_unlocks := {}

		for tower_enum in Data.Tower.values():
			var tower_data: Dictionary = Data.TOWER_DATA[tower_enum]

			tower_unlocks[str(tower_enum)] = {
				"isUnlocked": tower_data.get("isUnlocked", false),
				"unlockable": tower_data.get("unlockable", false)
			}
			
		var enemy_met := {}

		for enemy_enum in Data.Enemy.values():
			var enemy_data: Dictionary = Data.ENEMY_DATA[enemy_enum]
			enemy_met[str(enemy_enum)] = enemy_data.get("isMet", false)

		var vm_map_unlocks := {}
		var vm_map_rewards := {}

		for map_number in Data.VM_MAP_DATA:
			var map_data: Dictionary = Data.VM_MAP_DATA[map_number]
			vm_map_unlocks[str(map_number)] = map_data.get("unlocked", false)
			vm_map_rewards[str(map_number)] = map_data.get("reward_collected", false)

		# Save enemy kill counts
		var enemy_kills := {}

		for enemy_type in EnemyStats.enemy_kills:
			enemy_kills[str(enemy_type)] = EnemyStats.enemy_kills[enemy_type]

		print("SAVED TOWERS: ", placed_towers)
		print("SAVED SENTINELS: ", placed_sentinels)
		print("SAVED ABILITIES: ", placed_abilities)
		print("==============================")
		var save_data := {
			"version": SAVE_VERSION,
			"current_level_index": Data.current_level_index, "checkpoint_wave": Data.checkpoint_wave,
			"current_wave": Data.current_wave, "money": Data.money, "max_health": Data.max_health,
			"maxserverload": Data.maxserverload, "server_points": Data.server_points,
			"player_level": Data.player_level, "experience": Data.experience,
			"owned_towers": Data.owned_towers,
			"placed_towers": placed_towers,
			"placed_sentinels": placed_sentinels,
			"placed_abilities": placed_abilities,
			"tower_unlocks": tower_unlocks,
			"sentinel_unlocks": sentinel_unlocks,
			"enemy_met": enemy_met,
			"vm_map_unlocks": vm_map_unlocks,
			"vm_map_rewards": vm_map_rewards,
			"sentinels": [Data.sentinel_ethical_deployed, Data.sentinel_sysad_deployed,
				Data.sentinel_intrusion_deployed, Data.sentinel_security_deployed,
				Data.sentinel_malware_deployed, Data.sentinel_deception_deployed],
			"enemy_kills": enemy_kills,
			"tower_upgrades": tower_upgrades,
			"offense_levels": Offense.offense_levels, "offense_maxed": Offense.maxed,
			"offense_stats": [Offense.multiplied_total_dmg, Offense.multiplied_atk_speed, Offense.multiplied_crit_chance],
			"defense_levels": Defense.defense_levels, "defense_maxed": Defense.maxed,
			"defense_stats": [Defense.total_armor, Defense.total_server_health, Defense.total_skill_cooldown, Defense.total_sentinel_deployed],
			"economy_levels": Economy.economy_levels, "economy_maxed": Economy.maxed,
			"economy_stats": [Economy.gold_multiplier, Economy.exp_multiplier],
		}

		var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(save_data))



func apply_vm_map_reward(map_number: int, gold: int, points: int) -> void:
	var parsed: Dictionary = {"version": SAVE_VERSION}

	if FileAccess.file_exists(SAVE_PATH):
		var read_file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if read_file:
			var loaded = JSON.parse_string(read_file.get_as_text())
			if loaded is Dictionary and loaded.get("version", 0) == SAVE_VERSION:
				parsed = loaded

	parsed["money"] = int(parsed.get("money", Data.before_total_money)) + gold
	parsed["server_points"] = int(parsed.get("server_points", Data.before_server_points)) + points

	var vm_map_rewards: Dictionary = parsed.get("vm_map_rewards", {})
	vm_map_rewards[str(map_number)] = true
	parsed["vm_map_rewards"] = vm_map_rewards

	var write_file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if write_file:
		write_file.store_string(JSON.stringify(parsed))


func _load_game() -> void:
	if Data.is_vmmode:
		return
	if !Data.is_sandbox:
		if not FileAccess.file_exists(SAVE_PATH):
			return
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if not file:
			return
		var parsed = JSON.parse_string(file.get_as_text())
		if not parsed is Dictionary or parsed.get("version", 0) != SAVE_VERSION:
			return

		Data.saved_tower_placements = parsed.get("placed_towers", [])

		Data.saved_sentinel_placements = parsed.get("placed_sentinels", [])
		Data.saved_ability_placements = parsed.get("placed_abilities", [])
		Data.current_level_index = int(parsed.get("current_level_index", Data.current_level_index))
		Data.checkpoint_wave = int(parsed.get("checkpoint_wave", Data.checkpoint_wave))
		Data.current_wave = int(parsed.get("current_wave", Data.current_wave))
		Data.money = int(parsed.get("money", Data.money))
		Data.max_health = float(parsed.get("max_health", Data.max_health))
		Data.maxserverload = int(parsed.get("maxserverload", Data.maxserverload))
		Data.server_points = int(parsed.get("server_points", Data.server_points))
		Data.player_level = int(parsed.get("player_level", Data.player_level))
		Data.experience = int(parsed.get("experience", Data.experience))

		var saved_owned_towers: Dictionary = parsed.get("owned_towers", {})
		Data.owned_towers.clear()
		for tower_key in saved_owned_towers:
			Data.owned_towers[int(tower_key)] = int(saved_owned_towers[tower_key])
		
		var tower_unlocks: Dictionary = parsed.get("tower_unlocks", {})

		for tower_key in tower_unlocks:
			var tower_enum := int(tower_key)

			if Data.TOWER_DATA.has(tower_enum):
				var saved_unlock: Dictionary = tower_unlocks[tower_key]

				Data.TOWER_DATA[tower_enum]["isUnlocked"] = bool(
					saved_unlock.get("isUnlocked", false)
				)

				Data.TOWER_DATA[tower_enum]["unlockable"] = bool(
					saved_unlock.get("unlockable", false)
				)
			
		var sentinels: Array = parsed.get("sentinels", [])
		if sentinels.size() >= 6:
			Data.sentinel_ethical_deployed = bool(sentinels[0])
			Data.sentinel_sysad_deployed = bool(sentinels[1])
			Data.sentinel_intrusion_deployed = bool(sentinels[2])
			Data.sentinel_security_deployed = bool(sentinels[3])
			Data.sentinel_malware_deployed = bool(sentinels[4])
			Data.sentinel_deception_deployed = bool(sentinels[5])

		var sentinel_unlocks: Dictionary = parsed.get("sentinel_unlocks", {})

		for sentinel_key in sentinel_unlocks:
			var sentinel_enum := int(sentinel_key)

			if Data.SENTINEL_DATA.has(sentinel_enum):
				Data.SENTINEL_DATA[sentinel_enum]["isUnlocked"] = bool(sentinel_unlocks[sentinel_key])
		
		var enemy_met: Dictionary = parsed.get("enemy_met", {})

		for enemy_key in enemy_met:
			var enemy_enum := int(enemy_key)

			if Data.ENEMY_DATA.has(enemy_enum):
				Data.ENEMY_DATA[enemy_enum]["isMet"] = bool(enemy_met[enemy_key])

		var vm_map_unlocks: Dictionary = parsed.get("vm_map_unlocks", {})

		for map_key in vm_map_unlocks:
			var map_number := int(map_key)

			if Data.VM_MAP_DATA.has(map_number):
				Data.VM_MAP_DATA[map_number]["unlocked"] = bool(vm_map_unlocks[map_key])

		var vm_map_rewards: Dictionary = parsed.get("vm_map_rewards", {})

		for reward_map_key in vm_map_rewards:
			var reward_map_number := int(reward_map_key)

			if Data.VM_MAP_DATA.has(reward_map_number):
				Data.VM_MAP_DATA[reward_map_number]["reward_collected"] = bool(vm_map_rewards[reward_map_key])

		var tower_upgrades: Dictionary = parsed.get("tower_upgrades", {})
		for tower_key in tower_upgrades:
			var tower_enum := int(tower_key)
			if not Data.TOWER_DATA.has(tower_enum):
				continue
			var saved_tower: Dictionary = tower_upgrades[tower_key]
			var levels: Array = saved_tower.get("levels", [])
			var stats: Dictionary = saved_tower.get("stats", {})
			var tower_data: Dictionary = Data.TOWER_DATA[tower_enum]
			for index in mini(levels.size(), 6):
				tower_data["upgrade%dlevel" % (index + 1)] = int(levels[index])
			for stat_name in stats:
				tower_data[stat_name] = stats[stat_name]

		var offense_stats: Array = parsed.get("offense_stats", [])
		Offense.offense_levels = Array(parsed.get("offense_levels", Offense.offense_levels), TYPE_INT, &"", null)
		Offense.maxed = Array(parsed.get("offense_maxed", Offense.maxed), TYPE_BOOL, &"", null)
		if offense_stats.size() >= 3:
			Offense.multiplied_total_dmg = float(offense_stats[0])
			Offense.multiplied_atk_speed = float(offense_stats[1])
			Offense.multiplied_crit_chance = float(offense_stats[2])

		var defense_stats: Array = parsed.get("defense_stats", [])
		Defense.defense_levels = Array(parsed.get("defense_levels", Defense.defense_levels), TYPE_INT, &"", null)
		Defense.maxed = Array(parsed.get("defense_maxed", Defense.maxed), TYPE_BOOL, &"", null)
		if defense_stats.size() >= 4:
			Defense.total_armor = float(defense_stats[0])
			Defense.total_server_health = int(defense_stats[1])
			Defense.total_skill_cooldown = float(defense_stats[2])
			Defense.total_sentinel_deployed = int(defense_stats[3])

		var economy_stats: Array = parsed.get("economy_stats", [])
		Economy.economy_levels = Array(parsed.get("economy_levels", Economy.economy_levels), TYPE_INT, &"", null)
		Economy.maxed = Array(parsed.get("economy_maxed", Economy.maxed), TYPE_BOOL, &"", null)
		if economy_stats.size() >= 2:
			Economy.gold_multiplier = float(economy_stats[0])
			Economy.exp_multiplier = float(economy_stats[1])
		
		var enemy_kills: Dictionary = parsed.get("enemy_kills", {})

		EnemyStats.enemy_kills.clear()

		for enemy_key in enemy_kills:
			var enemy_type := int(enemy_key)
			EnemyStats.enemy_kills[enemy_type as Data.Enemy] = int(enemy_kills[enemy_key])
		

func _restore_saved_objects() -> void:
	if !Data.is_sandbox:
		_restore_saved_sentinels()
		_restore_saved_abilities()


func _restore_saved_sentinels() -> void:
	if Data.saved_sentinel_placements.is_empty():
		return

	var sentinel_manager = get_tree().get_first_node_in_group("SentinelManager")

	if sentinel_manager == null:
		print("SentinelManager not found!")
		return

	for saved in Data.saved_sentinel_placements:
		var sentinel_type := int(saved.get("type", 0))

		var pos: Array = saved.get("cell_pos", [0, 0])
		var cell_pos := Vector2i(
			int(pos[0]),
			int(pos[1])
		)

		sentinel_manager.restore_sentinel(
			sentinel_type as Data.Sentinel,
			cell_pos
		)

func _restore_saved_abilities() -> void:
	if Data.saved_ability_placements.is_empty():
		return

	var ability_manager = get_tree().get_first_node_in_group("AbilityManager")

	if ability_manager == null:
		print("AbilityManager not found!")
		return

	for saved in Data.saved_ability_placements:
		var ability_type: String = saved.get("type", "")

		var pos: Array = saved.get("position", [0, 0])
		var position := Vector2(
			float(pos[0]),
			float(pos[1])
		)

		ability_manager.restore_ability(
			ability_type,
			position
		)
