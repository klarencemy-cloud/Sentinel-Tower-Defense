extends Node

var gold_multiplier: float = 1.0
var exp_multiplier: float = 1.0
var server_load_bonus: float = 0.0

const GOLD_MULT_INCREMENT: float = 0.1
const EXP_MULT_INCREMENT: float = 0.1
const SERVER_LOAD_INCREMENT: float = 0.05

var economy_levels: Array[int] = [0, 0, 0]
var maxed: Array[bool] = [false, false, false]

# Costs change level 6
var gold_cost_tier: int = 1
var exp_cost_tier: int = 1
var server_cost_tier: int = 1


func _gold_drop() -> void:
	#gold_multiplier += GOLD_MULT_INCREMENT
	economy_levels[0] += 1


func _exp_rate() -> void:
	#exp_multiplier += EXP_MULT_INCREMENT
	economy_levels[1] += 1


func _server_load() -> void:
	#server_load_bonus += SERVER_LOAD_INCREMENT
	economy_levels[2] += 1