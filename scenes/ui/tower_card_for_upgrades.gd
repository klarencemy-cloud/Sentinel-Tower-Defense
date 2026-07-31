extends Button

# var id: Data.Tower = Data.Tower.BASIC
var id: Data.Tower
var cost: int
var UpgradeUI = "res://scenes/upgrade/upgrade.tscn"
signal press(tower_enum: Data.Tower)
	
func setup(new_id: Data.Tower):
	id = new_id
	$TextureRect/Label.text = Data.TOWER_DATA[id]['name']
	$TextureRect/Label2.text = str(Data.TOWER_DATA[id]['cost'])
	$TextureRect/TextureRect.texture = load(Data.TOWER_DATA[id]['thumbnail'])


func _ready() -> void:
	# cost = Data.TOWER_DATA[Data.Tower.BASIC]['cost']
	pass
func _on_pressed() -> void:
	var upgrade_ui = get_parent().get_parent().get_parent().get_parent()
	upgrade_ui.set_selected_tower(id)
