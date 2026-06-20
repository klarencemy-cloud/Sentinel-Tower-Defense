extends CanvasLayer

@onready var auto_label: Label = $Control/AutoLabel
@onready var tower_enemies_button: TextureButton = $Control/TextureRect/HBoxContainer/TowerEnemiesButton
@onready var wave_button: TextureButton = $Control/TextureRect/HBoxContainer/WaveButton
@onready var sandbox_setting: TextureButton = $Control/TextureRect/HBoxContainer/SandboxSetting
@onready var tower_cards_container: HBoxContainer = $Control/TextureRect/TowerCardsContainer
@onready var enemy_cards_container: HBoxContainer = $Control/TextureRect/EnemyCardsContainer

signal place_tower(tower_type: Data.Tower)
signal spawn_enemy(enemy_type: Data.Enemy)
signal start_wave

var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")
var enemy_card_scene = preload("res://scenes/ui/enemy_card.tscn")


func _ready() -> void:
	tower_cards_container.visible = true
	enemy_cards_container.visible = false
	Data.server_load_changed.connect(update_server_load)
	$Control/TextureRect/TowerCardsContainer.visible = true
	$Control/TextureRect/EnemyCardsContainer.visible = false

	if Data.is_sandbox:
		sandbox_setting.visible = true
		tower_enemies_button.visible = true
		auto_label.visible = false # alis visible ng auto button
		wave_button.disabled = true # disable start wave button

	
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

	update_server_load()

	
	print("Stats Updated: Money - " + str(money) + ", Health - " + str(health) + ", " + "Max Load - " + str(Data.currentserverload) + " / " + str(Data.maxserverload))


func update_wave_label() -> void:
	$Control/TextureRect/PlayerCurrentStats/WaveNum.text = "Wave " + str(Data.current_wave + 1) + " /50"


func is_auto_enabled() -> bool:
	var auto_button = $Control/AutoLabel/AutoButton
	return auto_button.is_pressed()

func disable_auto():
	var auto_button = $Control/AutoLabel/AutoButton
	auto_button.button_pressed = false

func _on_wave_button_pressed() -> void:
	start_wave.emit()


func _on_pause_button_pressed() -> void:
	$PauseMenu.visible = true
	get_tree().paused = true


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
		Data.before_max_server_load = Data.maxserverload

		Data.maxserverload = 999999

	else:
		Data.is_unli_senti_cap = false
		Data.maxserverload = Data.before_max_server_load
	
	update_server_load()
		
func update_server_load():
	var progress_bar = $Control/TextureProgressBar
	
	if Data.is_unli_senti_cap:
		$Control/TextureProgressBar/ServerLoadText/SystemLoadData.text = str(Data.currentserverload) + " / " + "∞"
		progress_bar.value = 0
	else:
		$Control/TextureProgressBar/ServerLoadText/SystemLoadData.text = str(Data.currentserverload) + " / " + str(Data.maxserverload)
		
		if Data.maxserverload > 0:
			var load_pct = (float(Data.currentserverload) / float(Data.maxserverload)) * 100.0
			progress_bar.value = load_pct
		else:
			progress_bar.value = 0


func refresh_tower_cards():
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.toggle_active(Data.money)


func _on_stats_counter_button_pressed() -> void:
	if $EnemyTowerStatsCounter.visible == false:
		$EnemyTowerStatsCounter.visible = true
	else:
		$EnemyTowerStatsCounter.visible = false
