extends Button

var id: Data.Tower = Data.Tower.BASIC
var cost: int
signal press(tower_enum: Data.Tower)
	
func setup(new_id: Data.Tower):
	id = new_id
	$TextureRect/TowerName.text = Data.TOWER_DATA[id]['name']
	$TextureRect/ServerLoad.text = str(Data.TOWER_DATA[id]['server_load'])
	$TextureRect/TowerCost.text = str(cost)
	$TextureRect/TextureRect.texture = load(Data.TOWER_DATA[id]['thumbnail'])


func _ready() -> void:
	if not is_in_group("TowerCard"):
		add_to_group("TowerCard")

	# ensure cost is set even if setup wasn't called before ready
	cost = Data.TOWER_DATA[id]['cost']
	$TextureRect/TowerCost.text = str(cost)
	toggle_active(Data.money)


func toggle_active(_money: int = 0):
	var tower_load = Data.TOWER_DATA[id]["server_load"]

	var can_afford_money = Data.is_unli_money or cost <= Data.money
	var can_afford_load = Data.currentserverload + tower_load <= Data.maxserverload

	disabled = not (can_afford_money and can_afford_load)

func _on_pressed() -> void:
	press.emit(id)
