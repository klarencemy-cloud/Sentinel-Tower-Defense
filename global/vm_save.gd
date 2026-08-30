extends Node

const SAVE_PATH := "user://vm_savegame.json"
const SAVE_VERSION := 1


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

	var save_data := {
		"version": SAVE_VERSION,
		"map_number": Data.vmmode_map_number,
		"virus_kills": vmmode_node.virus_kills if vmmode_node else 0,
		"health": Data.health,
		"placed_towers": placed_towers,
		"placed_sentinels": placed_sentinels,
		"placed_abilities": placed_abilities,
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func load_into_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or parsed.get("version", 0) != SAVE_VERSION:
		return {}

	Data.saved_tower_placements = parsed.get("placed_towers", [])
	Data.saved_sentinel_placements = parsed.get("placed_sentinels", [])
	Data.saved_ability_placements = parsed.get("placed_abilities", [])

	return parsed


func clear_save() -> void:
	Data.saved_tower_placements.clear()
	Data.saved_sentinel_placements.clear()
	Data.saved_ability_placements.clear()
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
