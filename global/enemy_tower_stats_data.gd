extends Node

var tower_info: Dictionary = {}

var tower_damage: Dictionary = {}

signal tower_registered(tower_id: int)
signal tower_damage_changed(tower_id: int)
signal tower_removed(tower_id: int)

func register_tower(tower_id: int, tower_type: Data.Tower) -> void:
	var tower_data = Data.TOWER_DATA[tower_type]
	tower_info[tower_id] = {
		"name": tower_data["name"],
		"thumbnail": tower_data["thumbnail"]
	}
	tower_damage[tower_id] = 0
	tower_registered.emit(tower_id)

func add_damage(tower_id: int, damage: int) -> void:
	if not tower_damage.has(tower_id):
		return
	tower_damage[tower_id] += damage
	tower_damage_changed.emit(tower_id)

func remove_tower(tower_id: int) -> void:
	tower_info.erase(tower_id)
	tower_damage.erase(tower_id)
	tower_removed.emit(tower_id)

func get_sorted_towers() -> Array:
	var result = []
	for tower_id in tower_damage.keys():
		result.append({
			"tower_id": tower_id,
			"damage": tower_damage[tower_id]
		})
	result.sort_custom(func(a, b): return a["damage"] > b["damage"])
	return result

func get_max_damage() -> int:
	var max_dmg = 0
	for tower_id in tower_damage:
		max_dmg = max(max_dmg, tower_damage[tower_id])
	return max_dmg

func reset() -> void:
	tower_info.clear()
	tower_damage.clear()

var _backup_damage: Dictionary = {}
var _backup_info: Dictionary = {}

func backup() -> void:
	_backup_damage = tower_damage.duplicate(true)
	_backup_info = tower_info.duplicate(true)

func restore_backup() -> void:
	tower_damage = _backup_damage.duplicate(true)
	tower_info = _backup_info.duplicate(true)
	_backup_damage = {}
	_backup_info = {}

func get_save_data() -> Dictionary:
	var data := {}
	for tower_id in tower_damage:
		data[str(tower_id)] = tower_damage[tower_id]
	return data

func load_damage_save_data(data: Dictionary) -> void:
	for key in data:
		var tower_id := int(key)
		if not tower_damage.has(tower_id):
			continue
		tower_damage[tower_id] = int(data[key])
		tower_damage_changed.emit(tower_id)