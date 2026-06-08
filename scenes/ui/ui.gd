extends CanvasLayer
signal place_tower(tower_type: Data.Tower)
signal spawn_enemy(enemy_type: Data.Enemy)
signal start_wave

var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")
var enemy_card_scene = preload("res://scenes/ui/enemy_card.tscn")

var tower_menu: bool #toggles tower card menu
var sandbox_setting : bool #sandbox menu toggle
var tower_cards_showing: bool = true #toggles between tower and enemy cards in sandbox menu


func _ready() -> void:
	$Control/TextureRect/TowerCardsContainer.visible = true
	$Control/TextureRect/EnemyCardsContainer.visible = false
	

	
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$Control/TextureRect/TowerCardsContainer.add_child(tower_card)
		tower_card.connect('press', tower_select)


	for enemy_enum in Data.Enemy.values():
		var enemy_card = enemy_card_scene.instantiate()
		enemy_card.setup(enemy_enum)
		$Control/TextureRect/EnemyCardsContainer.add_child(enemy_card)
		enemy_card.connect('press', sandbox_spawn_enemy)

	update_stats(Data.money, Data.health)
	update_wave_label()


func tower_select(tower_enum: Data.Tower):
	place_tower.emit(tower_enum)

func sandbox_spawn_enemy(enemy_enum: Data.Enemy):
	spawn_enemy.emit(enemy_enum)

func update_stats(money: int, health: int):
	if Data.is_sandbox:
		$Control/StatsContainer/PanelContainer2/HBoxContainer/Label.text = "∞"
		$Control/TextureRect/PlayerCurrentStats/LabelHP.text = "∞"
		$Control/TextureRect/PlayerCurrentStats/HPBar.value = 100 
	else:
		$Control/StatsContainer/PanelContainer2/HBoxContainer/Label.text = str(money)
		$Control/TextureRect/PlayerCurrentStats/LabelHP.text = str(health)
		$Control/TextureRect/PlayerCurrentStats/HPBar.value = health * 100 / 100




func update_wave_label() -> void:
	$Control/TextureRect/PlayerCurrentStats/WaveNum.text = "Wave " + str(Data.current_wave + 1) + " /50"


func is_auto_enabled() -> bool:
	var auto_button = $Control/AutoLabel/AutoButton
	return auto_button.is_pressed()


func _on_wave_button_pressed() -> void:
	start_wave.emit()


func _on_pause_button_pressed() -> void:
	$PauseMenu.visible = true
	get_tree().paused = true


func _on_sandbox_setting_pressed() -> void:
	if sandbox_setting:
		sandbox_setting = false
		$Control/TextureRect/PlayerCurrentStats.visible = true
		$Control/TextureRect/SandboxMenuContainer.visible = false
	else:
		sandbox_setting = true
		$Control/TextureRect/PlayerCurrentStats.visible = false
		$Control/TextureRect/SandboxMenuContainer.visible = true
	


func _on_tower_enemies_button_pressed() -> void:
	if tower_cards_showing:
		$Control/TextureRect/TowerCardsContainer.visible = false
		$Control/TextureRect/EnemyCardsContainer.visible = true
		tower_cards_showing = false
	else:
		$Control/TextureRect/TowerCardsContainer.visible = true
		$Control/TextureRect/EnemyCardsContainer.visible = false
		tower_cards_showing = true
