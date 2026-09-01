extends VMWaveChallenge

const TOTAL_WAVES := 7

const WAVES: Array[Dictionary] = [
	{
		"name": "Initial Infection",
		"composition": {Data.Enemy.VIRUS: 18, Data.Enemy.WORM: 6},
		"spawn_interval": 1.10,
		"hp_mult": 1.00,
	},
	{
		"name": "Propagation",
		"composition": {Data.Enemy.VIRUS: 12, Data.Enemy.WORM: 16, Data.Enemy.ADWARE: 8},
		"spawn_interval": 1.00,
		"hp_mult": 1.00,
	},
	{
		"name": "Surveillance",
		"composition": {Data.Enemy.ADWARE: 14, Data.Enemy.SPYWARE: 12, Data.Enemy.WORM: 10},
		"spawn_interval": 0.95,
		"hp_mult": 1.05,
	},
	{
		"name": "Command & Control",
		"composition": {Data.Enemy.BOTNET: 14, Data.Enemy.SPYWARE: 10, Data.Enemy.VIRUS: 12},
		"spawn_interval": 0.90,
		"hp_mult": 1.10,
	},
	{
		"name": "Payload Delivery",
		"composition": {Data.Enemy.TROJAN: 10, Data.Enemy.ROOTKIT: 10, Data.Enemy.BOTNET: 10},
		"spawn_interval": 0.90,
		"hp_mult": 1.15,
	},
	{
		"name": "Encryption",
		"composition": {Data.Enemy.RANSOMWARE: 14, Data.Enemy.ZERO: 8, Data.Enemy.ROOTKIT: 8, Data.Enemy.TROJAN: 6},
		"spawn_interval": 0.85,
		"hp_mult": 1.20,
	},
	{
		"name": "ILOVEYOU",
		"boss": Data.Enemy.BOSS1,
		"composition": {Data.Enemy.WORM: 20, Data.Enemy.BOTNET: 10, Data.Enemy.RANSOMWARE: 8, Data.Enemy.ZERO: 6},
		"spawn_interval": 0.80,
		"hp_mult": 1.25,
	},
]


func _wave_challenge_setup() -> void:
	Data.max_health = 1
	Data.health = 1
	Data.clear_notpetya_enemy_speed_effect()


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]


func _on_challenge_server_damaged(_amount: float) -> void:
	_end_session(false)


func _restore_progress(progress: Dictionary) -> void:
	super._restore_progress(progress)
	Data.health = 1
