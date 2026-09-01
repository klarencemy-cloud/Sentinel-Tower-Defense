extends VMWaveChallenge

const TOTAL_WAVES := 7
const INITIAL_GRANTS := 4
const INTERMISSION_GRANTS := 2

const WAVES: Array[Dictionary] = [
	{
		"name": "First Contact",
		"composition": {Data.Enemy.DEFAULT: 14, Data.Enemy.VIRUS: 12, Data.Enemy.ADWARE: 8},
		"spawn_interval": 0.90,
		"hp_mult": 1.00,
	},
	{
		"name": "Escalation",
		"composition": {Data.Enemy.VIRUS: 12, Data.Enemy.WORM: 14, Data.Enemy.SPYWARE: 10, Data.Enemy.BOTNET: 6},
		"spawn_interval": 0.85,
		"hp_mult": 1.08,
	},
	{
		"name": "Credential Theft",
		"composition": {Data.Enemy.CREDS: 14, Data.Enemy.SPYWARE: 12, Data.Enemy.BOTNET: 10, Data.Enemy.TROJAN: 8},
		"spawn_interval": 0.80,
		"hp_mult": 1.15,
	},
	{
		"name": "Insider Access",
		"composition": {Data.Enemy.INSIDERTHREAT: 14, Data.Enemy.TROJAN: 12, Data.Enemy.BOTNET: 10, Data.Enemy.CREDS: 8},
		"spawn_interval": 0.78,
		"hp_mult": 1.22,
	},
	{
		"name": "Database Breach",
		"composition": {Data.Enemy.SQL: 14, Data.Enemy.ROOTKIT: 12, Data.Enemy.INSIDERTHREAT: 10, Data.Enemy.TROJAN: 8},
		"spawn_interval": 0.75,
		"hp_mult": 1.30,
	},
	{
		"name": "Flood Prep",
		"composition": {Data.Enemy.DDOS: 8, Data.Enemy.ROOTKIT: 12, Data.Enemy.SQL: 10, Data.Enemy.RANSOMWARE: 8},
		"spawn_interval": 0.72,
		"hp_mult": 1.35,
	},
	{
		"name": "NotPetya",
		"boss": Data.Enemy.BOSS4,
		"composition": {Data.Enemy.DDOS: 10, Data.Enemy.RANSOMWARE: 12, Data.Enemy.ROOTKIT: 10, Data.Enemy.SQL: 10},
		"spawn_interval": 0.70,
		"hp_mult": 1.40,
	},
]

func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()
	Data.free_towers.clear()
	Data.money = 0
	Economy.gold_multiplier = 0.0

	_grant_random_towers(INITIAL_GRANTS)


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]


func _on_intermission_started() -> void:
	_grant_random_towers(INTERMISSION_GRANTS)


func _grant_random_towers(count: int) -> void:
	for i in range(count):
		var tower_enum := _random_unlocked_tower()
		if tower_enum == -1:
			continue
		Data.free_towers[tower_enum] = Data.free_towers.get(tower_enum, 0) + 1

	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()


func _random_unlocked_tower() -> int:
	var candidates: Array = []
	for tower_enum in Data.Tower.values():
		if Data.TOWER_DATA[tower_enum].get('isUnlocked', false):
			candidates.append(tower_enum)
	if candidates.is_empty():
		return -1
	return candidates.pick_random()


func _serialize_progress() -> Dictionary:
	var progress := super._serialize_progress()
	var saved_free_towers := {}
	for tower_enum in Data.free_towers:
		saved_free_towers[str(int(tower_enum))] = Data.free_towers[tower_enum]
	progress["free_towers"] = saved_free_towers
	return progress


func _restore_progress(progress: Dictionary) -> void:
	super._restore_progress(progress)
	if progress.has("free_towers"):
		var saved_free_towers: Dictionary = progress.get("free_towers", {})
		Data.free_towers.clear()
		for key in saved_free_towers:
			Data.free_towers[int(key)] = int(saved_free_towers[key])
