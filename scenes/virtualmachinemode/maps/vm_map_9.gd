extends VMWaveChallenge

const BASE_COUNT := 12
const COUNT_PER_WAVE := 3
const HP_GROWTH := 1.06
const SPEED_GROWTH := 1.02
const SPAWN_INTERVAL_BASE := 0.85
const SPAWN_INTERVAL_DECAY := 0.01
const SPAWN_INTERVAL_MIN := 0.30
const BOSS_INTERVAL := 10

const ROSTER_UNLOCKS: Array[Dictionary] = [
	{"wave": 1, "type": Data.Enemy.SPAM},
	{"wave": 1, "type": Data.Enemy.VIRUS},
	{"wave": 3, "type": Data.Enemy.ADWARE},
	{"wave": 5, "type": Data.Enemy.WORM},
	{"wave": 7, "type": Data.Enemy.SPYWARE},
	{"wave": 9, "type": Data.Enemy.BOTNET},
	{"wave": 11, "type": Data.Enemy.CREDS},
	{"wave": 13, "type": Data.Enemy.TROJAN},
	{"wave": 15, "type": Data.Enemy.INSIDERTHREAT},
	{"wave": 17, "type": Data.Enemy.ROOTKIT},
	{"wave": 19, "type": Data.Enemy.SQL},
	{"wave": 21, "type": Data.Enemy.DDOS},
	{"wave": 23, "type": Data.Enemy.RANSOMWARE},
	{"wave": 25, "type": Data.Enemy.ZERO},
]

const BOSSES: Array[Data.Enemy] = [
	Data.Enemy.BOSS1,
	Data.Enemy.BOSS2,
	Data.Enemy.BOSS3,
	Data.Enemy.BOSS4,
	Data.Enemy.BOSS5,
]


func _use_story_wave_position() -> bool:
	return true


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()


func _is_endless() -> bool:
	return true


func _wave_for_index(wave_index: int) -> Dictionary:
	var wave_num: int = wave_index + 1
	var roster: Array = _roster_for_wave(wave_num)

	var count: int = BASE_COUNT + COUNT_PER_WAVE * wave_num
	var per_type: int = max(1, count / roster.size())

	var composition: Dictionary = {}
	for enemy_type in roster:
		composition[enemy_type] = per_type

	var wave_data: Dictionary = {
		"composition": composition,
		"spawn_interval": max(SPAWN_INTERVAL_BASE - SPAWN_INTERVAL_DECAY * wave_num, SPAWN_INTERVAL_MIN),
		"hp_mult": pow(HP_GROWTH, wave_num),
		"speed_mult": pow(SPEED_GROWTH, wave_num),
	}

	if wave_num % BOSS_INTERVAL == 0:
		@warning_ignore("integer_division")
		var boss_index: int = (wave_num / BOSS_INTERVAL - 1) % BOSSES.size()
		wave_data["boss"] = BOSSES[boss_index]

	return wave_data


func _roster_for_wave(wave_num: int) -> Array:
	var roster: Array = []
	for entry in ROSTER_UNLOCKS:
		if wave_num >= int(entry["wave"]):
			roster.append(entry["type"])
	if roster.is_empty():
		roster.append(Data.Enemy.SPAM)
	return roster

