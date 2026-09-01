extends VMWaveChallenge

# Botnet-only swarm - fast, fragile drones (absolute overrides, not a
# multiplier off Botnet's base 200 HP / 105 speed - see plan for rationale).
# Wave 7 is led by BOSS2 (Conficker), a real botnet worm.
const TOTAL_WAVES := 7

const WAVES: Array[Dictionary] = [
	{
		"name": "Compromise",
		"composition": {Data.Enemy.BOTNET: 30},
		"spawn_interval": 0.55,
		"hp_override": 50,
		"speed_override": 170,
	},
	{
		"name": "Propagation",
		"composition": {Data.Enemy.BOTNET: 42},
		"spawn_interval": 0.50,
		"hp_override": 55,
		"speed_override": 175,
	},
	{
		"name": "Swarm Growth",
		"composition": {Data.Enemy.BOTNET: 54},
		"spawn_interval": 0.48,
		"hp_override": 58,
		"speed_override": 180,
	},
	{
		"name": "Coordinated Flood",
		"composition": {Data.Enemy.BOTNET: 66},
		"spawn_interval": 0.45,
		"hp_override": 62,
		"speed_override": 185,
	},
	{
		"name": "Amplification",
		"composition": {Data.Enemy.BOTNET: 78},
		"spawn_interval": 0.42,
		"hp_override": 65,
		"speed_override": 190,
	},
	{
		"name": "Peak Saturation",
		"composition": {Data.Enemy.BOTNET: 90},
		"spawn_interval": 0.40,
		"hp_override": 68,
		"speed_override": 195,
	},
	{
		"name": "Conficker",
		"boss": Data.Enemy.BOSS2,
		"composition": {Data.Enemy.BOTNET: 90},
		"spawn_interval": 0.38,
		"hp_override": 70,
		"speed_override": 200,
	},
]


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]
