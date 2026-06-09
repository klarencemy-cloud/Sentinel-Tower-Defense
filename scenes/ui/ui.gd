extends CanvasLayer
signal place_tower(tower_type: Data.Tower)
signal spawn_enemy(enemy_type: Data.Enemy)
signal start_wave

var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")
var enemy_card_scene = preload("res://scenes/ui/enemy_card.tscn")

var sandbox_setting : bool #sandbox menu toggle
var tower_cards_showing: bool = true #toggles between tower and enemy cards in sandbox menu

func _ready() -> void:
	$Control/TextureRect/TowerCardsContainer.visible = true
	$Control/TextureRect/EnemyCardsContainer.visible = false

	if Data.is_sandbox:
		$Control/TextureRect/HBoxContainer/SandboxSetting.visible = true
		$Control/TextureRect/HBoxContainer/TowerEnemiesButton.visible = true

	
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

#sandbox
func sandbox_spawn_enemy(enemy_enum: Data.Enemy):
	spawn_enemy.emit(enemy_enum)

func update_stats(money: int, health: int):

	if Data.is_unli_money:
		$Control/StatsContainer/PanelContainer2/HBoxContainer/Label.text = "∞"
	else:
		$Control/StatsContainer/PanelContainer2/HBoxContainer/Label.text = str(money)
		
	if Data.is_unli_health:
		$Control/TextureRect/PlayerCurrentStats/LabelHP.text = "∞"
		$Control/TextureRect/PlayerCurrentStats/HPBar.value = 100
	else:
		$Control/TextureRect/PlayerCurrentStats/LabelHP.text = str(health)
		$Control/TextureRect/PlayerCurrentStats/HPBar.value = health * 100 / 100
	print("Stats Updated: Money - " + str(money) + ", Health - " + str(health))



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
		$Control/TextureRect/HBoxContainer/TowerEnemiesButton.texture_normal = load("res://graphics/ui/tower_card_button.png")
		tower_cards_showing = false
	else:
		$Control/TextureRect/TowerCardsContainer.visible = true
		$Control/TextureRect/EnemyCardsContainer.visible = false
		$Control/TextureRect/HBoxContainer/TowerEnemiesButton.texture_normal = load("res://graphics/ui/enemy_card_button.png")
		tower_cards_showing = true


func _on_maxed_lvl_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Data.is_maxed_lvl = true
	else:
		Data.is_maxed_lvl = false


func _on_unli_money_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Data.is_unli_money = true
		Data.before_total_money = Data.money
		Data.money = 999999

	else:
		Data.is_unli_money = false
		Data.money = Data.before_total_money


func _on_unli_health_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Data.is_unli_health = true
		Data.before_total_health = Data.health
		
		Data.health = 999999

	else:
		Data.is_unli_health = false
		Data.health = Data.before_total_health


func _on_unli_senti_cap_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Data.is_unli_senti_cap = true
	else:
		Data.is_unli_senti_cap = false
