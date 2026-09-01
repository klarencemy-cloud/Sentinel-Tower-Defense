extends VMWaveChallenge

const TOTAL_WAVES := 7

const WAVES: Array[Dictionary] = [
	{
		"name": "Perimeter Test",
		"composition": {Data.Enemy.CREDS: 14, Data.Enemy.SPYWARE: 12, Data.Enemy.BOTNET: 10},
		"spawn_interval": 0.85,
		"hp_mult": 1.00,
	},
	{
		"name": "Lateral Movement",
		"composition": {Data.Enemy.INSIDERTHREAT: 14, Data.Enemy.TROJAN: 12, Data.Enemy.BOTNET: 10, Data.Enemy.CREDS: 8},
		"spawn_interval": 0.80,
		"hp_mult": 1.10,
	},
	{
		"name": "Privilege Escalation",
		"composition": {Data.Enemy.ROOTKIT: 14, Data.Enemy.INSIDERTHREAT: 12, Data.Enemy.TROJAN: 10, Data.Enemy.SQL: 8},
		"spawn_interval": 0.78,
		"hp_mult": 1.18,
	},
	{
		"name": "Data Exfiltration",
		"composition": {Data.Enemy.SQL: 14, Data.Enemy.ROOTKIT: 12, Data.Enemy.TROJAN: 10, Data.Enemy.ZERO: 8},
		"spawn_interval": 0.75,
		"hp_mult": 1.26,
	},
	{
		"name": "Zero-Day Exploit",
		"composition": {Data.Enemy.ZERO: 16, Data.Enemy.ROOTKIT: 12, Data.Enemy.SQL: 10, Data.Enemy.RANSOMWARE: 8},
		"spawn_interval": 0.72,
		"hp_mult": 1.34,
	},
	{
		"name": "Traffic Flood",
		"composition": {Data.Enemy.DDOS: 10, Data.Enemy.RANSOMWARE: 14, Data.Enemy.ZERO: 12, Data.Enemy.ROOTKIT: 10},
		"spawn_interval": 0.70,
		"hp_mult": 1.42,
	},
	{
		"name": "MyDoom",
		"boss": Data.Enemy.BOSS5,
		"composition": {Data.Enemy.DDOS: 12, Data.Enemy.RANSOMWARE: 14, Data.Enemy.ZERO: 12, Data.Enemy.SQL: 10},
		"spawn_interval": 0.68,
		"hp_mult": 1.50,
	},
]


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]
