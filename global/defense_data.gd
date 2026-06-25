extends Node

var total_armor: float = 0.0 # total armor or dmg reduction
var total_skill_slot: int = 0 # total skill slot added
var total_skill_cooldown: float = 0.0 # total skill cd reduc
var total_sentinel_deployed: int = 0 # total senti deployed added

const dmg_reduc: float = 0.03
const skill_add: int = 1
const cd_reduc: float = 0.05
const senti_add: int = 1

func _armor_damage_reduction() -> void:
	total_armor += dmg_reduc


func _skill_slot_add() -> void:
	total_skill_slot += skill_add


func _skill_cooldown_reduction() -> void:
	total_skill_cooldown += cd_reduc


func _sentinel_deployed_add() -> void:
	total_sentinel_deployed += senti_add


func _dmg_reduc_armor(actual_dmg: int):
	return (actual_dmg - (actual_dmg * total_armor))