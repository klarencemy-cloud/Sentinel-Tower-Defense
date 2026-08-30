extends Node

signal points_changed

var gold_multiplier: float = 1.0
var exp_multiplier: float = 1.0

var before_gold_multiplier: float = 1.0
var before_exp_multiplier: float = 1.0
var before_economy_levels: Array[int] = [0, 0, 0]
var before_maxed: Array[bool] = [false, false, false]

const base_gold_multiplier: float = 1.0
const base_exp_multiplier: float = 1.0

const GOLD_MULT_INCREMENT: float = 0.05
const EXP_MULT_INCREMENT: float = 0.05
const SERVER_LOAD_INCREMENT: int = 50

var economy_levels: Array[int] = [0, 0, 0]
var maxed: Array[bool] = [false, false, false]

# Costs change level 6
var gold_cost_tier: int = 1
var exp_cost_tier: int = 1
var server_cost_tier: int = 1


func _gold_drop() -> void:
	gold_multiplier += GOLD_MULT_INCREMENT
	economy_levels[0] += 1


func _exp_rate() -> void:
	exp_multiplier += EXP_MULT_INCREMENT
	economy_levels[1] += 1


func _server_load() -> void:
	Data.maxserverload += SERVER_LOAD_INCREMENT
	points_changed.emit()
	economy_levels[2] += 1


func _sandbox_mode() -> void:
	before_gold_multiplier = gold_multiplier
	before_exp_multiplier = exp_multiplier
	before_economy_levels = economy_levels.duplicate()
	before_maxed = maxed.duplicate()
	_reset_multipliers()
	_reset_levels()


func _restore_original_server_stats() -> void:
	gold_multiplier = before_gold_multiplier
	exp_multiplier = before_exp_multiplier
	economy_levels = before_economy_levels.duplicate()
	maxed = before_maxed.duplicate()


func _reset_multipliers() -> void:
	gold_multiplier = base_gold_multiplier
	exp_multiplier = base_exp_multiplier


func _reset_levels() -> void:
	economy_levels = [0, 0, 0]
	maxed = [false, false, false]

const VMMODE_LEVEL_CAPS: Array[int] = [8, 8, 8]


func _apply_vmmode_fixed_levels(map_number: int) -> void:
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[0])):
		_gold_drop()
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[1])):
		_exp_rate()
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[2])):
		_server_load()