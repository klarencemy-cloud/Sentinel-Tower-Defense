extends Node

signal server_health_upgraded(new_max_health: float)

var total_armor: float = 0.0          # total armor or dmg reduction
var total_server_health: int = 0      # total server health added
var total_skill_cooldown: float = 0.0 # total skill cd reduc
var total_sentinel_deployed: int = 0  # total senti deployed added

var before_dmg_reduc: float = 0.0
var before_server_health: int = 0
var before_skill_cooldown: float = 0.0
var before_sentinel_deployed: int = 0

const base_armor: float = 0.0
const base_skill_slot: int = 0
const base_skill_cooldown: float = 0.0
const base_sentinel_deployed: int = 0

const dmg_reduc: float = 0.03
const server_health_add: int = 50
const cd_reduc: float = 0.05
const senti_add: int = 1

var before_defense_levels: Array[int] = [0, 0, 0, 0]
var before_maxed: Array[bool] = [false, false, false, false]

var defense_levels: Array[int] = [0, 0, 0, 0]
var maxed: Array[bool] = [false, false, false, false]

var server_health_slot_price: int = 2
var sentinel_slot_price: int = 2


func _armor_damage_reduction() -> void:
	total_armor += dmg_reduc
	defense_levels[0] += 1 


func _server_health() -> void:
	total_server_health += server_health_add
	defense_levels[1] += 1
	Data.max_health += server_health_add  # Increases max health but not the current health
	server_health_upgraded.emit(Data.max_health)


func _skill_cooldown_reduction() -> void:
	total_skill_cooldown += cd_reduc
	defense_levels[2] += 1 


func _sentinel_deployed_add() -> void:
	total_sentinel_deployed += senti_add
	defense_levels[3] += 1 # track sentinel upgrade level


func _dmg_reduc_armor(actual_dmg: int):
	return (actual_dmg - (actual_dmg * total_armor))


func _sandbox_mode() -> void:
	before_dmg_reduc = total_armor
	before_server_health = total_server_health
	before_skill_cooldown = total_skill_cooldown
	before_sentinel_deployed = total_sentinel_deployed
	before_defense_levels = defense_levels.duplicate()
	before_maxed = maxed.duplicate()
	_reset_multipliers()
	_reset_levels()


func _restore_original_server_stats() -> void:
	total_armor = before_dmg_reduc
	total_server_health = before_server_health
	total_skill_cooldown = before_skill_cooldown
	total_sentinel_deployed = before_sentinel_deployed
	defense_levels = before_defense_levels.duplicate()
	maxed = before_maxed.duplicate()


func _reset_multipliers() -> void:
	total_armor = 0.0
	total_server_health = 0
	total_skill_cooldown = 0.0
	total_sentinel_deployed = 0


func _reset_levels() -> void:
	defense_levels = [0, 0, 0, 0]
	maxed = [false, false, false, false]