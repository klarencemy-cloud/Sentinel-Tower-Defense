extends Node

const dmg_multiplier: float = 0.02
const atk_speed_multiplier: float = 0.02
const crit_chance_multiplier: float = 0.05

const base_dmg: float = 1.0
const base_atk_speed: float = 0.0
const base_crit_chance: float = 0.0

var before_total_dmg: float = 1.0
var before_total_atk_speed: float = 0.0
var before_total_crit_chance: float = 0.0

var before_offense_levels: Array[int] = [0, 0, 0]
var before_maxed: Array[bool] = [false, false, false]

var multiplied_total_dmg: float = 1.0
var multiplied_atk_speed: float = 0.0
var multiplied_crit_chance: float = 0.0



var offense_levels: Array[int] = [0, 0, 0]
var maxed: Array[bool] = [false, false, false]

func _inc_dmg() -> void:
	multiplied_total_dmg += dmg_multiplier
	offense_levels[0] += 1


func _tower_speed() -> void:
	multiplied_atk_speed += atk_speed_multiplier
	offense_levels[1] += 1


func _crit_chance() -> void:
	multiplied_crit_chance += crit_chance_multiplier
	offense_levels[2] += 1


func _sandbox_mode() -> void:
	before_total_dmg = multiplied_total_dmg
	before_total_atk_speed = multiplied_atk_speed
	before_total_crit_chance = multiplied_crit_chance
	before_offense_levels = offense_levels.duplicate()
	before_maxed = maxed.duplicate()
	_reset_multipliers()
	_reset_levels()


func _restore_original_server_stats() -> void:
	multiplied_total_dmg = before_total_dmg
	multiplied_atk_speed = before_total_atk_speed
	multiplied_crit_chance = before_total_crit_chance
	offense_levels = before_offense_levels.duplicate()
	maxed = before_maxed.duplicate()


func _reset_multipliers() -> void:
	multiplied_total_dmg = 1.0
	multiplied_atk_speed = 0.0
	multiplied_crit_chance = 0.0


func _reset_levels() -> void:
	offense_levels = [0, 0, 0]
	maxed = [false, false, false]

const VMMODE_LEVEL_CAPS: Array[int] = [8, 8, 8]


func _apply_vmmode_fixed_levels(map_number: int) -> void:
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[0])):
		_inc_dmg()
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[1])):
		_tower_speed()
	for i in range(mini(map_number, VMMODE_LEVEL_CAPS[2])):
		_crit_chance()
