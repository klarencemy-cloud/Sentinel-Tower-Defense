extends Node

const SAVE_PATH := "user://vm_savegame.json"
const SAVE_VERSION := 2


func _read_all() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or parsed.get("version", 0) != SAVE_VERSION:
		return {}
	return parsed


func _write_all(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))


func save_game() -> void:
	if !Data.is_vmmode:
		return

	var placed_towers: Array = []
	for tower in get_tree().get_nodes_in_group("Towers"):
		if tower is Tower:
			placed_towers.append({
				"type": int(tower.type),
				"cell_pos": [tower.cell_pos.x, tower.cell_pos.y]
			})

	var placed_sentinels: Array = []
	for sentinel in get_tree().get_nodes_in_group("Sentinels"):
		if sentinel.has_meta("sentinel_type"):
			placed_sentinels.append({
				"type": int(sentinel.get_meta("sentinel_type")),
				"cell_pos": [sentinel.cell_pos.x, sentinel.cell_pos.y]
			})

	var placed_abilities: Array = []
	for ability in get_tree().get_nodes_in_group("Abilities"):
		placed_abilities.append({
			"type": "firewall",
			"position": [ability.position.x, ability.position.y]
		})

	var vmmode_node = get_tree().get_first_node_in_group("vmmode_session")

	var all_data := _read_all()
	if all_data.is_empty():
		all_data = {"version": SAVE_VERSION, "maps": {}}
	if not all_data.has("maps"):
		all_data["maps"] = {}

	all_data["maps"][str(Data.vmmode_map_number)] = {
		"progress": vmmode_node._serialize_progress() if vmmode_node else {},
		"health": Data.health,
		"money": Data.money,
		"placed_towers": placed_towers,
		"placed_sentinels": placed_sentinels,
		"placed_abilities": placed_abilities,
		"stats": {
			"enemy_kills": EnemyStats.get_save_data(),
			"tower_damage": EnemyTower.get_save_data(),
		},
	}

	_write_all(all_data)


func has_save(map_number: int) -> bool:
	var all_data := _read_all()
	return all_data.get("maps", {}).has(str(map_number))


func load_into_data(map_number: int) -> Dictionary:
	var all_data := _read_all()
	var slot: Dictionary = all_data.get("maps", {}).get(str(map_number), {})
	if slot.is_empty():
		return {}

	Data.saved_tower_placements = slot.get("placed_towers", [])
	Data.saved_sentinel_placements = slot.get("placed_sentinels", [])
	Data.saved_ability_placements = slot.get("placed_abilities", [])

	var progress: Dictionary = slot.get("progress", {}).duplicate()
	if slot.has("health"):
		progress["health"] = slot["health"]
	if slot.has("money"):
		progress["money"] = slot["money"]
	if slot.has("stats"):
		progress["stats"] = slot["stats"]
	return progress


func clear_save(map_number: int) -> void:
	Data.saved_tower_placements.clear()
	Data.saved_sentinel_placements.clear()
	Data.saved_ability_placements.clear()

	var all_data := _read_all()
	var maps: Dictionary = all_data.get("maps", {})
	maps.erase(str(map_number))

	if maps.is_empty():
		if FileAccess.file_exists(SAVE_PATH):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	else:
		all_data["maps"] = maps
		_write_all(all_data)
