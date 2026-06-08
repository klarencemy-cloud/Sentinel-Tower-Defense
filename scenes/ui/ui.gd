extends CanvasLayer
signal place_tower(tower_type: Data.Tower)
signal start_wave

var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")

func _ready() -> void:
	$Control/TextureRect/TowerCardsContainer.visible = true

	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$Control/TextureRect/TowerCardsContainer.add_child(tower_card)
		tower_card.connect('press', tower_select)
	update_stats(Data.money, Data.health)
	update_wave_label()


func tower_select(tower_enum: Data.Tower):
	place_tower.emit(tower_enum)


func update_stats(money: int, health: int):
	$Control/StatsContainer/PanelContainer2/HBoxContainer/Label.text = str(money)
	$Control/TextureRect/LabelHP.text = str(health)
	$Control/TextureRect/HPBar.value = Data.health * 100 / 100


func update_wave_label() -> void:
	$Control/TextureRect/WaveNum.text = "Wave " + str(Data.current_wave + 1) + " /50"


func is_auto_enabled() -> bool:
	var auto_button = $Control/AutoLabel/AutoButton
	return auto_button.is_pressed()


func _on_wave_button_pressed() -> void:
	start_wave.emit()


func _on_pause_button_pressed() -> void:
	$PauseMenu.visible = true
	
