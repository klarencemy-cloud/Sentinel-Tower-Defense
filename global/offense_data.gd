extends Node

var total_dmg: float = 1.0
var total_atk_speed: float = 1.0
var total_crit_chance: float = 0.0

const dmg_multiplier: float = 0.02

var offense_levels: Array[int] = [0, 0, 0]
var maxed: Array[bool] = [false, false, false]

func _inc_dmg() -> void:
	total_dmg += dmg_multiplier


func _tower_speed() -> void:
	pass

func _crit_chance() -> void:
	pass

func get_tower_stats(tower_enum: Data.Tower) -> Dictionary:
	var base = Data.TOWER_DATA[tower_enum].duplicate(true)
	
	base["damage"] *= total_dmg
	base["reload_time"] /= total_atk_speed 
	base["crit rate"] += total_crit_chance
	
	base["reload_time"] = maxf(base["reload_time"], 0.05)
	
	return base
