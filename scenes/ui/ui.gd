extends CanvasLayer

@onready var auto_label: Label = $Control/AutoLabel
@onready var tower_enemies_button: TextureButton = $Control/TextureRect/HBoxContainer/TowerEnemiesButton
@onready var wave_button: TextureButton = $Control/TextureRect/HBoxContainer/WaveButton
@onready var sandbox_setting: TextureButton = $Control/TextureRect/HBoxContainer/SandboxSetting
@onready var tower_cards_container: HBoxContainer = $Control/TextureRect/ScrollContainer/TowerCardsContainer
@onready var enemy_cards_container: HBoxContainer = $Control/TextureRect/ScrollContainer/EnemyCardsContainer

signal place_tower(tower_type: Data.Tower)
signal spawn_enemy(enemy_type: Data.Enemy)
signal start_wave

var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")
var enemy_card_scene = preload("res://scenes/ui/enemy_card.tscn")
var ad_popup_scene = preload("res://scenes/ads.tscn")

var ad_timer := Timer.new()
@onready var ad_textures := [
	preload("res://graphics/buttons/ad1.png"),
	preload("res://graphics/buttons/ad2.png"),
	preload("res://graphics/buttons/ad3.png"),
	preload("res://graphics/buttons/ad4.png"),
	preload("res://graphics/buttons/ad5.png")
]
func _ready() -> void:
	Data.ads_visible = false
	Data.active_adware = 0
	Data.active_adware_changed.connect(_schedule_next_ad)
	add_child(ad_timer)
	ad_timer.one_shot = true
	ad_timer.timeout.connect(_spawn_random_ad)

	_schedule_next_ad()
	tower_cards_container.visible = true
	enemy_cards_container.visible = false
	Data.server_load_changed.connect(update_server_load)
	$Control/TextureRect/ScrollContainer/TowerCardsContainer.visible = true
	$Control/TextureRect/ScrollContainer/EnemyCardsContainer.visible = false
	

	Data.toggle_server_scene.connect(_show_server_upgrade)

	if Data.is_sandbox:
		sandbox_setting.visible = true
		tower_enemies_button.visible = true
		auto_label.visible = false # alis visible ng auto button
		wave_button.disabled = true # disable start wave button
		$Control/HBoxContainer.position.y = 780

	
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$Control/TextureRect/ScrollContainer/TowerCardsContainer.add_child(tower_card)
		tower_card.connect('press', tower_select)


	for enemy_enum in Data.Enemy.values():
		var enemy_card = enemy_card_scene.instantiate()
		enemy_card.setup(enemy_enum)
		$Control/TextureRect/ScrollContainer/EnemyCardsContainer.add_child(enemy_card)
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

var is_shown: bool

func _show_server_upgrade() -> void:
	if !is_shown:
		$ServerUpgrade.visible = true
		$Control.visible = false
		is_shown = true
	else:
		$ServerUpgrade.visible = false
		$Control.visible = true
		is_shown = false

func _schedule_next_ad():
	print("Active adware:", Data.active_adware)
	if Data.active_adware <= 0:
		print("No adware, not starting timer.")
		ad_timer.stop()
		return

	# More adware = shorter delay
	var delay = randf_range(5.0,8.0) / Data.active_adware
	print("Starting timer for", delay, "seconds")
	ad_timer.start(delay)

func _spawn_random_ad():
	print("Spawning ad")
	if Data.active_adware <= 0:
		return

	var popup = ad_popup_scene.instantiate()
	add_child(popup)

	popup.setup(ad_textures.pick_random())
	Data.ads_visible = true

	await get_tree().process_frame

	var size = popup.size

	popup.position = Vector2(
	randf_range(0, get_viewport().size.x - size.x),
	randf_range(0, get_viewport().size.y - size.y))
	_schedule_next_ad()
