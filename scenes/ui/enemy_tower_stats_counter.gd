extends CanvasLayer


@onready var kill_button: TextureButton = $Container/Content/KillButton
@onready var tower_button: TextureButton = $Container/Content/TowerButton
@onready var scroll_container: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer
@onready var scroll_container_2: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer2

# Tower damage UI
@onready var tower_scroll: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer
@onready var tower_vbox: VBoxContainer = $Container/Content/DmgCounterBg/ScrollContainer/VBoxContainer
@onready var tower_entry_template: Panel = $Container/Content/DmgCounterBg/ScrollContainer/VBoxContainer/TowerEntry

# Enemy kill UI 
@onready var enemy_scroll: ScrollContainer = $Container/Content/DmgCounterBg/ScrollContainer2
@onready var enemy_vbox: VBoxContainer = $Container/Content/DmgCounterBg/ScrollContainer2/VBoxContainer
@onready var enemy_entry_template: Panel = $Container/Content/DmgCounterBg/ScrollContainer2/VBoxContainer/EnemyEntry

var tower_entries: Dictionary = {}
var enemy_entries: Dictionary = {}

func _ready() -> void:
	# Setup tower section
	tower_vbox.remove_child(tower_entry_template)

	# Setup enemy section 
	enemy_vbox.remove_child(enemy_entry_template)

	# Connect tower signals
	EnemyTower.tower_registered.connect(_on_tower_registered)
	EnemyTower.tower_damage_changed.connect(_on_tower_damage_changed)
	EnemyTower.tower_removed.connect(_on_tower_removed)

	# Connect enemy signals 
	EnemyStats.enemy_killed.connect(_on_enemy_killed)

	# Init existing towers
	for tower_id in EnemyTower.tower_info.keys():
		_add_or_update_tower_entry(tower_id)

	# Init existing enemies 
	for enemy_type in EnemyStats.enemy_kills.keys():
		_add_or_update_enemy_entry(enemy_type)

	# Preaload active buttons
	kill_button.texture_normal = preload("res://graphics/ui/tmid_counter_enemy.png")
	tower_button.texture_normal = preload("res://graphics/ui/tmid_counter_button_tower.png")



#TOWER DAMAGE SECTION

func _on_tower_registered(tower_id: int) -> void:
	_add_or_update_tower_entry(tower_id)

func _on_tower_damage_changed(tower_id: int) -> void:
	_add_or_update_tower_entry(tower_id)

func _on_tower_removed(tower_id: int) -> void:
	if tower_entries.has(tower_id):
		tower_entries[tower_id].queue_free()
		tower_entries.erase(tower_id)
	_refresh_tower_entries()

func _add_or_update_tower_entry(tower_id: int) -> void:
	var entry = tower_entries.get(tower_id)
	if entry == null:
		entry = tower_entry_template.duplicate(true)
		entry.visible = true
		entry.name = "TowerEntry_%s" % tower_id
		tower_vbox.add_child(entry)
		tower_entries[tower_id] = entry

	var info = EnemyTower.tower_info.get(tower_id, {})
	var damage = EnemyTower.tower_damage.get(tower_id, 0)
	var thumbnail = info.get("thumbnail", "")
	var tower_name = info.get("name", "Tower")

	var tower_image = entry.find_child("TowerImage", true, false) as TextureRect
	if tower_image:
		tower_image.texture = null
		if thumbnail != "":
			var tex = load(thumbnail)
			if tex:
				tower_image.texture = tex

	var tower_damage_lbl = entry.find_child("TowerDamageLbl", true, false) as Label
	if tower_damage_lbl:
		tower_damage_lbl.text = "%s #%s\nDamage: %s" % [tower_name, tower_id, damage]

	_refresh_tower_entries()

func _refresh_tower_entries() -> void:
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

		tower_vbox.move_child(entry, i)

		var progress_bar = entry.find_child("TextureProgressBarDmg", true, false) as TextureProgressBar
		if progress_bar:
			progress_bar.max_value = 100
			progress_bar.value = float(damage) / max_damage * 100.0

# ENEMY KILL SECTION

func _on_enemy_killed(enemy_type: Data.Enemy, _new_count: int) -> void:
	_add_or_update_enemy_entry(enemy_type)

func _add_or_update_enemy_entry(enemy_type: Data.Enemy) -> void:
	var entry = enemy_entries.get(enemy_type)
	if entry == null:
		entry = enemy_entry_template.duplicate(true)
		entry.visible = true
		entry.name = "EnemyEntry_%s" % enemy_type
		enemy_vbox.add_child(entry)
		enemy_entries[enemy_type] = entry

	var info = EnemyStats.enemy_info.get(enemy_type, {})
	var kills = EnemyStats.enemy_kills.get(enemy_type, 0)
	var texture_path = info.get("texture", "")
	var enemy_name = info.get("name", "Enemy")

	var enemy_image = entry.find_child("EnemyImage", true, false) as TextureRect
	if enemy_image:
		enemy_image.texture = null
		if texture_path != "":
			var tex = load(texture_path)
			if tex:
				enemy_image.texture = tex

	#enemy name
	var enemy_name_lbl = entry.find_child("EnemyNameLbl", true, false) as Label
	if enemy_name_lbl:
		enemy_name_lbl.text = enemy_name.capitalize()

	#enemy kill count
	var kill_count_lbl = entry.find_child("KillCountLbl", true, false) as Label
	if kill_count_lbl:
		kill_count_lbl.text = "Kill Count: %s" % kills

	_refresh_enemy_entries()

func _refresh_enemy_entries() -> void:
	var enemy_list = []
	for enemy_type in enemy_entries.keys():
		var kills = EnemyStats.enemy_kills.get(enemy_type, 0)
		enemy_list.append({"enemy_type": enemy_type, "kills": kills})

	enemy_list.sort_custom(func(a, b): return a["kills"] > b["kills"])

	var max_kills = EnemyStats.get_max_kills()
	if max_kills == 0:
		max_kills = 1

	for i in range(enemy_list.size()):
		var enemy_type = enemy_list[i]["enemy_type"]
		var kills = enemy_list[i]["kills"]
		var entry = enemy_entries[enemy_type]

		enemy_vbox.move_child(entry, i)

		#progress bar for enemy kills
		var progress_bar = entry.find_child("TextureProgressBarDmg", true, false) as TextureProgressBar
		if progress_bar:
			progress_bar.max_value = 100
			progress_bar.value = float(kills) / max_kills * 100.0


func _on_kill_button_pressed() -> void:
	scroll_container.visible = false
	scroll_container_2.visible = true
	kill_button.texture_normal = preload("res://graphics/ui/tmid_counter_enemy.png")
	tower_button.texture_normal = preload("res://graphics/ui/tmid_counter_button_tower.png")

func _on_tower_button_pressed() -> void:
	scroll_container.visible = true
	scroll_container_2.visible = false
	kill_button.texture_normal = preload("res://graphics/ui/tmid_counter_button.png")
	tower_button.texture_normal = preload("res://graphics/ui/tmid_counter_tower_active.png")
