extends CanvasLayer

@onready var scroll_container: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer
@onready var scroll_container_2: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer2
@onready var vbox_container: VBoxContainer = $Container/Content/DmgCounterBg/ScrollContainer/VBoxContainer
@onready var tower_entry_template: Panel = $Container/Content/DmgCounterBg/ScrollContainer/VBoxContainer/TowerEntry



var tower_entries: Dictionary = {}

func _ready() -> void:
	vbox_container.remove_child(tower_entry_template)
	tower_entry_template.visible = false

	EnemyTower.tower_registered.connect(_on_tower_registered)
	EnemyTower.tower_damage_changed.connect(_on_tower_damage_changed)
	EnemyTower.tower_removed.connect(_on_tower_removed)

	for tower_id in EnemyTower.tower_info.keys():
		_add_or_update_tower_entry(tower_id)

func _on_tower_registered(tower_id: int) -> void:
	_add_or_update_tower_entry(tower_id)

func _on_tower_damage_changed(tower_id: int) -> void:
	_add_or_update_tower_entry(tower_id)

func _on_tower_removed(tower_id: int) -> void:
	if tower_entries.has(tower_id):
		tower_entries[tower_id].queue_free()
		tower_entries.erase(tower_id)
	_refresh_all_entries()

func _add_or_update_tower_entry(tower_id: int) -> void:
	var entry = tower_entries.get(tower_id)
	if entry == null:
		entry = tower_entry_template.duplicate(true)
		entry.visible = true
		entry.name = "TowerEntry_%s" % tower_id
		vbox_container.add_child(entry)
		tower_entries[tower_id] = entry

	var info = EnemyTower.tower_info.get(tower_id, {})
	var damage = EnemyTower.tower_damage.get(tower_id, 0)
	var thumbnail = info.get("thumbnail", "")
	var tower_name = info.get("name", "Tower")

	var tower_image = entry.find_child("TowerImage", true, false) as TextureRect
	if tower_image and thumbnail != "":
		tower_image.texture = load(thumbnail)

	var tower_damage_lbl = entry.find_child("TowerDamageLbl", true, false) as Label
	if tower_damage_lbl:
		tower_damage_lbl.text = "%s #%s\nDamage: %s" % [tower_name, tower_id, damage]

	_refresh_all_entries()

func _refresh_all_entries() -> void:
	var tower_list = []
	for tower_id in tower_entries.keys():
		var damage = EnemyTower.tower_damage.get(tower_id, 0)
		tower_list.append({"tower_id": tower_id, "damage": damage})

	tower_list.sort_custom(func(a, b): return a["damage"] > b["damage"])

	var max_damage = EnemyTower.get_max_damage()
	if max_damage == 0:
		max_damage = 1

	for i in range(tower_list.size()):
		var tower_id = tower_list[i]["tower_id"]
		var damage = tower_list[i]["damage"]
		var entry = tower_entries[tower_id]

		vbox_container.move_child(entry, i)

		var progress_bar = entry.find_child("TextureProgressBarDmg", true, false) as TextureProgressBar
		if progress_bar:
			progress_bar.max_value = 100
			progress_bar.value = float(damage) / max_damage * 100.0


func _on_kill_button_pressed() -> void:
	scroll_container.visible = false
	scroll_container_2.visible = true


func _on_tower_button_pressed() -> void:
	scroll_container.visible = true
	scroll_container_2.visible = false
