extends Button

var id: Data.Tower
var cost: int
var UpgradeUI = "res://scenes/upgrade/upgrade.tscn"
signal press(tower_enum: Data.Tower)

func setup(new_id: Data.Tower):
	id = new_id
	
	$TextureRect/Label.text = Data.TOWER_DATA[id]["name"]
	$TextureRect/Label2.text = str(Data.TOWER_DATA[id]["cost"])
	$TextureRect/TextureRect.texture = load(Data.TOWER_DATA[id]["thumbnail"])
	
	update_unlock_status()

func _ready() -> void:
	pass


func _on_pressed() -> void:
	var upgrade_ui = get_parent().get_parent().get_parent().get_parent()
	upgrade_ui.set_selected_tower(id)

func update_unlock_status() -> void:
	if Data.TOWER_DATA[id]["isUnlocked"]:
		$TextureRect/TextureRect.modulate = Color(1, 1, 1, 1)
		$TextureRect/Label.text = Data.TOWER_DATA[id]["name"]
		$TextureRect/towerlocked.visible = false
	else:
		$TextureRect/TextureRect.modulate = Color(0, 0, 0, 1)
		$TextureRect/Label.text = "???"
		$TextureRect/towerlocked.visible = true
