extends Node

const dmg_multiplier: float = 0.02
const atk_speed_multiplier: float = 0.02
const crit_chance_multiplier: float = 0.05

const base_dmg: float = 1.0
const base_atk_speed: float = 0.0
const base_crit_chance: float = 0.0

var multiplied_total_dmg: float = 1.0
var multiplied_atk_speed: float = 0.0
var multiplied_crit_chance: float = 0.0



var offense_levels: Array[int] = [0, 0, 0]
var maxed: Array[bool] = [false, false, false]

func _inc_dmg() -> void:
	multiplied_total_dmg += dmg_multiplier


func _tower_speed() -> void:
	multiplied_atk_speed += atk_speed_multiplier


func _crit_chance() -> void:
	multiplied_crit_chance += crit_chance_multiplier


func _reset_multipliers() -> void:
	multiplied_total_dmg = 1.0
	multiplied_atk_speed = 0.0
	multiplied_crit_chance = 0.0


func _reset_levels() -> void:
	offense_levels = [0, 0, 0]
	maxed = [false, false, false]