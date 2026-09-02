extends Button

var item_id: int = -1
var kind: String = "tower"
var type_id: int = -1

signal press(item_id: int)

func setup(item: Dictionary) -> void:
	item_id = item["id"]
	kind = item["kind"]
	type_id = item["type"]

	if kind == "tower":
		var tower_data: Dictionary = Data.TOWER_DATA[type_id]
		$TextureRect/ItemName.text = tower_data["name"]
		$TextureRect/Thumbnail.texture = load(tower_data["thumbnail"])
		$TextureRect/ItemCost.text = "0"
		$TextureRect/ItemLoad.text = str(tower_data["server_load"])
	else:
		var sentinel_data: Dictionary = Data.SENTINEL_DATA[type_id]
		$TextureRect/ItemName.text = sentinel_data["name"].capitalize()
		$TextureRect/Thumbnail.texture = load(sentinel_data["thumbnail"])
		$TextureRect/ItemCost.text = "0"
		$TextureRect/ItemLoad.visible = false

	_update_availability()


func _ready() -> void:
	Data.server_load_changed.connect(_update_availability)
	Data.vm_belt_selection_changed.connect(_on_selection_changed)


func _update_availability() -> void:
	if kind != "tower":
		disabled = false
		return
	var load: int = Data.TOWER_DATA[type_id]["server_load"]
	disabled = not Data.is_unli_senti_cap and Data.currentserverload + load > Data.maxserverload


func _on_selection_changed() -> void:
	set_selected(Data.vm_belt_selected_id == item_id)


func set_selected(selected: bool) -> void:
	modulate = Color(0.6, 0.6, 0.6, 1.0) if selected else Color.WHITE


func _on_pressed() -> void:
	UISound.play_click()
	press.emit(item_id)
