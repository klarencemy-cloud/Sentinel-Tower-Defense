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
		"hp_override": 100,
		"speed_override": 165,
	},
	{
		"name": "Propagation",
		"composition": {Data.Enemy.BOTNET: 40},
		"spawn_interval": 0.52,
		"hp_override": 145,
		"speed_override": 170,
	},
	{
		"name": "Swarm Growth",
		"composition": {Data.Enemy.BOTNET: 50},
		"spawn_interval": 0.48,
		"hp_override": 210,
		"speed_override": 175,
	},
	{
		"name": "Coordinated Flood",
		"composition": {Data.Enemy.BOTNET: 60},
		"spawn_interval": 0.45,
		"hp_override": 290,
		"speed_override": 180,
	},
	{
		"name": "Amplification",
		"composition": {Data.Enemy.BOTNET: 70},
		"spawn_interval": 0.42,
		"hp_override": 370,
		"speed_override": 185,
	},
	{
		"name": "Peak Saturation",
		"composition": {Data.Enemy.BOTNET: 80},
		"spawn_interval": 0.40,
		"hp_override": 460,
		"speed_override": 190,
	},
	{
		"name": "Conficker",
		"boss": Data.Enemy.BOSS2,
		"composition": {Data.Enemy.BOTNET: 60},
		"spawn_interval": 0.40,
		"hp_override": 540,
		"speed_override": 195,
	},
]


func _use_story_wave_position() -> bool:
	return true


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]
