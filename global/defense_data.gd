extends Node

var total_armor: float = 0.0          # total armor or dmg reduction
var total_skill_slot: int = 0         # total skill slot added
var total_skill_cooldown: float = 0.0 # total skill cd reduc
var total_sentinel_deployed: int = 0  # total senti deployed added

const base_armor: float = 0.0
const base_skill_slot: int = 0
const base_skill_cooldown: float = 0.0
const base_sentinel_deployed: int = 0

const dmg_reduc: float = 0.03
const skill_add: int = 1
const cd_reduc: float = 0.05
const senti_add: int = 1

var defense_levels: Array[int] = [0, 0, 0, 0]
var maxed: Array[bool] = [false, false, false, false]

var skill_slot_price: int = 2
var sentinel_slot_price: int = 2


func _armor_damage_reduction() -> void:
	total_armor += dmg_reduc
	defense_levels[0] += 1 


func _skill_slot_add() -> void:
	total_skill_slot += skill_add
	defense_levels[1] += 1 


func _skill_cooldown_reduction() -> void:
	total_skill_cooldown += cd_reduc
	defense_levels[2] += 1 


func _sentinel_deployed_add() -> void:
	total_sentinel_deployed += senti_add
	defense_levels[3] += 1 # track sentinel upgrade level


func _dmg_reduc_armor(actual_dmg: int):
	return (actual_dmg - (actual_dmg * total_armor))


func _reset_multipliers() -> void:
	total_armor = 0.0
	total_skill_slot = 0
	total_skill_cooldown = 0.0
	total_sentinel_deployed = 0


func _reset_levels() -> void:
	defense_levels = [0, 0, 0, 0]
	maxed = [false, false, false, false]