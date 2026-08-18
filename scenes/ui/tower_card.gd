extends Button

var id: Data.Tower
var cost: int
signal press(tower_enum: Data.Tower)
@onready var free_label = $TextureRect/Free/FreeLabel
@onready var free_badge = $TextureRect/Free
func setup(new_id: Data.Tower):
	id = new_id
	cost = Data.TOWER_DATA[id]["cost"]

	$TextureRect/TowerName.text = Data.TOWER_DATA[id]["name"]
	$TextureRect/ServerLoad.text = str(Data.TOWER_DATA[id]["server_load"])
	$TextureRect/TowerCost.text = str(cost)
	$TextureRect/TextureRect.texture = load(Data.TOWER_DATA[id]["thumbnail"])
	
func _ready() -> void:
	if not is_in_group("TowerCard"):
		add_to_group("TowerCard")

	Data.server_load_changed.connect(_on_server_load_changed)
	# ensure cost is set even if setup wasn't called before ready
	cost = Data.TOWER_DATA[id]['cost']
	$TextureRect/TowerCost.text = str(cost)
	toggle_active(Data.money)
	update_free_label()


func toggle_active(_money := 0):
	var load = Data.TOWER_DATA[id]["server_load"]
	var has_free = Data.free_towers.get(id, 0) > 0
	var can_buy = Data.is_unli_money or Data.money >= cost
	var can_use = has_free or can_buy
	var can_load = Data.currentserverload + load <= Data.maxserverload
	if id == Data.Tower.BACKUP_SERVER and Data.backup_server_placed:
		disabled = true
		return
	disabled = !(can_use and can_load)
	
func update_free_label():
	var amount = Data.free_towers.get(id, 0)

	free_badge.visible = amount > 0

	if amount > 0:
		free_label.text = str(amount)

func _on_pressed() -> void:
	UISound.play_click()
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.set_selected(false)

	set_selected(true)
	press.emit(id)
	
func _on_server_load_changed():
	toggle_active(Data.money)

func set_selected(selected: bool) -> void:
	if selected:
		modulate = Color(0.6, 0.6, 0.6, 1.0)
	else:
		modulate = Color.WHITE
