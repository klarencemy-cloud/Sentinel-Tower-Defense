extends CanvasLayer

@onready var auto_label: Label = $Control/AutoLabel
@onready var tower_enemies_button: TextureButton = $Control/TextureRect/HBoxContainer/TowerEnemiesButton
@onready var wave_button: TextureButton = $Control/TextureRect/HBoxContainer/WaveButton
@onready var sandbox_setting: TextureButton = $Control/TextureRect/HBoxContainer/SandboxSetting
@onready var tower_cards_container: HBoxContainer = $Control/TextureRect/ScrollContainer/TowerCardsContainer
@onready var sentinel_cards_container: HBoxContainer = $Control/TextureRect/ScrollContainer/SentinelCardsContainer
@onready var enemy_cards_container: HBoxContainer = $Control/TextureRect/ScrollContainer/EnemyCardsContainer
@onready var unli_money: CheckBox = $Control/TextureRect/SandboxMenuContainer/UnliMoney
@onready var unli_health: CheckBox = $Control/TextureRect/SandboxMenuContainer/UnliHealth
@onready var server_upgrade = $ServerUpgrade
@onready var server_pts_label: Label = server_upgrade.find_child("LabelServerPts", true, false)
@onready var boss_hp_bar = $Control/bosshpbar
@onready var boss_hp_amount = $Control/bosshpbar/hpamount
@onready var boss_name = $Control/bosshpbar/bossname
@onready var skill1_button: TextureButton = $Control/HBoxContainer/Skill1
@onready var skill2_button: TextureButton = $Control/HBoxContainer/Skill2
@onready var skill3_button: TextureButton = $Control/HBoxContainer/Skill3
@onready var skill1_cooldown: TextureProgressBar = $Control/HBoxContainer/Skill1/cooldown
@onready var skill2_cooldown: TextureProgressBar = $Control/HBoxContainer/Skill2/cooldown
@onready var skill3_cooldown: TextureProgressBar = $Control/HBoxContainer/Skill3/cooldown
@onready var boss_bars := [
	$Control/bosshpbar,
	$Control/smallhpbar1,
	$Control/smallhpbar2,
	$Control/smallhpbar3,
	$Control/smallhpbar4,
	$Control/smallhpbar5,
	$Control/smallhpbar6
]
@onready var skill3_locked: TextureRect = $Control/HBoxContainer/Skill3/Locked

var boss_bar_assignments := {} # boss_id -> ProgressBar


signal place_tower(tower_type: Data.Tower)
signal place_sentinel(sentinel_type: Data.Sentinel)
signal place_ability(ability: Data.Ability)
signal spawn_enemy(enemy_type: Data.Enemy)
signal start_wave


var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")
var enemy_card_scene = preload("res://scenes/ui/enemy_card.tscn")
var sentinel_card_scene = preload("res://scenes/ui/sentinel_card.tscn")

var tower_card_button_texture = preload("res://graphics/ui/tower_card_button.png")
var sentinel_card_button_texture = preload("res://graphics/ui/sentinel_card_button.png")
var enemy_card_button_texture = preload("res://graphics/ui/enemy_card_button.png")

enum CardCategory {TOWER, SENTINEL, ENEMY}
var fade_tween: Tween

var ad_timer := Timer.new()
var ransomware_timer := Timer.new()

var firewall_cooldown := 15.0
var firewall_on_cooldown := false
var firewall_timer := Timer.new()

var patch_cooldown := 15.0
var patch_on_cooldown := false
var patch_timer := Timer.new()

var backup_server_cooldown := 60.0
var backup_server_on_cooldown := false
var backup_server_timer := Timer.new()


@onready var ad_textures := [
	preload("res://graphics/buttons/ad1.png"),
	preload("res://graphics/buttons/ad2.png")
]
func _ready() -> void:
	UISound.stop_bg()
	await UISound.play_game_bg()
	UISound.play_air_bg()

	Defense.server_health_upgraded.connect(_on_server_health_upgraded)
	boss_hp_bar.visible = false
	Data.ads_visible = false
	Data.active_adware = 0
	Data.active_adware_changed.connect(_schedule_next_ad)
	add_child(ad_timer)
	ad_timer.one_shot = true
	ad_timer.timeout.connect(_spawn_random_ad)
	_schedule_next_ad()
	Data.active_adware = 0
	
	Data.active_ransomware_changed.connect(_schedule_next_ransomware)
	add_child(ransomware_timer)
	ransomware_timer.one_shot = true
	ransomware_timer.timeout.connect(_spawn_random_ransomware)
	
	show_card_category(CardCategory.TOWER)
	Data.server_load_changed.connect(update_server_load)
	

	Data.toggle_server_scene.connect(_show_server_upgrade)
	skill1_button.texture_normal = preload("res://graphics/ui/firewallbutton.png")
	skill1_button.pressed.connect(_on_skill1_pressed)


	skill2_button.texture_normal = preload("res://graphics/ui/patch.png")
	
	add_child(firewall_timer)
	firewall_timer.one_shot = true
	firewall_timer.wait_time = firewall_cooldown
	firewall_timer.timeout.connect(_on_firewall_cooldown_finished)
	
	skill1_cooldown.visible = false
	skill1_cooldown.value = 0
	
	add_child(patch_timer)
	patch_timer.one_shot = true
	patch_timer.wait_time = patch_cooldown
	patch_timer.timeout.connect(_on_patch_cooldown_finished)
	
	skill2_cooldown.visible = false
	skill2_cooldown.value = 0

	add_child(backup_server_timer)
	backup_server_timer.one_shot = true
	backup_server_timer.wait_time = backup_server_cooldown
	backup_server_timer.timeout.connect(_on_backup_server_cooldown_finished)

	skill3_cooldown.visible = false
	skill3_cooldown.value = 0

	if Data.is_sandbox:
		$Control/TextureRect/HBoxContainer/WaveButton.visible = true
		sandbox_setting.visible = true
		tower_enemies_button.visible = true
		auto_label.visible = false # alis visible ng auto button
		wave_button.disabled = true # disable start wave button
		Data.before_owned_towers = Data.owned_towers.duplicate()
		Data.owned_towers.clear()
		# Backup and reset tower upgrades for sandbox mode
		Data._initialize_base_tower_stats() # Ensure base stats are captured before backing up
		Data._backup_tower_upgrades()
		Data._reset_tower_upgrades_to_base()
		Offense._sandbox_mode()
		Defense._sandbox_mode()
		Economy._sandbox_mode()
		unli_money.button_pressed = true
		unli_health.button_pressed = true
		$Control/HBoxContainer.position.y = 780

	
	if Data.current_wave >= 5 or Data.is_sandbox:
		toggle_skill_activation()
	
	for tower_enum in Data.Tower.values():
		if tower_enum == Data.Tower.BACKUP_SERVER:
			continue
		var tower_data: Dictionary = Data.TOWER_DATA[tower_enum]

		if not tower_data.get("isUnlocked", false):
			if not (Data.is_sandbox and Data.DEVMODE):
				continue

		unlock_tower_card(tower_enum)


	if not (Data.is_vmmode and Data.vmmode_sentinels_disabled):
		for sentinel_enum in Data.Sentinel.values():
			var sentinel_data = Data.SENTINEL_DATA[sentinel_enum]

			if not sentinel_data.get("isUnlocked", false):
				if not (Data.is_sandbox and Data.DEVMODE):
					continue

			var sentinel_card = sentinel_card_scene.instantiate()
			sentinel_card.setup(sentinel_enum)
			$Control/TextureRect/ScrollContainer/SentinelCardsContainer.add_child(sentinel_card)
			sentinel_card.connect("press", sentinel_select)


	for enemy_enum in Data.Enemy.values():
		var enemy_data = Data.ENEMY_DATA[enemy_enum]

		if not enemy_data.get("isMet", false):
			if not (Data.is_sandbox and Data.DEVMODE):
				continue

		var enemy_card = enemy_card_scene.instantiate()
		enemy_card.setup(enemy_enum)
		$Control/TextureRect/ScrollContainer/EnemyCardsContainer.add_child(enemy_card)
		enemy_card.connect("press", sandbox_spawn_enemy)

	Economy.points_changed.connect(update_server_load)
	update_stats(Data.money, Data.health)
	update_experience(Data.experience, Data.player_level, Data.default_level_pool)
	update_wave_label()

	if not GameDialogueManager.is_skill_activated:
		$Control/HBoxContainer/Skill1.disabled = true
		$Control/HBoxContainer/Skill1.texture_normal = load("res://graphics/container/skillcontainer.png")
	
	else:
		$Control/HBoxContainer/Skill1.disabled = false
		$Control/HBoxContainer/Skill1.texture_normal = load("res://graphics/ui/firewallbutton.png")
	
	for bar in boss_bars:
		bar.visible = false

	skill3_locked.visible = Data.backup_server_placed

func _process(_delta: float) -> void:
	if firewall_on_cooldown:
		skill1_cooldown.value = firewall_timer.time_left
	
	if patch_on_cooldown:
		skill2_cooldown.value = patch_timer.time_left

	if backup_server_on_cooldown:
		skill3_cooldown.value = backup_server_timer.time_left

	if not Data.is_vmmode:
		$Control/TextureRect/HBoxContainer/WaveButton.visible = GameDialogueManager.button_state

func _on_skill_2_pressed() -> void:
	UISound.play_click()
	if patch_on_cooldown:
		return
	tower_select(11)

func tower_select(tower_enum: Data.Tower):
	place_tower.emit(tower_enum)


func sentinel_select(sentinel_enum: Data.Sentinel):
	place_sentinel.emit(sentinel_enum)

func toggle_skill_activation():
	GameDialogueManager.is_skill_activated = true
	$Control/HBoxContainer/Skill1.disabled = false
	$Control/HBoxContainer/Skill1.texture_normal = load("res://graphics/ui/firewallbutton.png")

func _on_skill1_pressed() -> void:
	UISound.play_click()
	if firewall_on_cooldown:
		return

	place_ability.emit(Data.Ability.FIREWALL)

func _on_firewall_cooldown_finished() -> void:
	firewall_on_cooldown = false
	skill1_button.disabled = false
	skill1_cooldown.visible = false

func start_firewall_cooldown() -> void:
	if firewall_on_cooldown:
		return

	firewall_on_cooldown = true
	skill1_button.disabled = true

	skill1_cooldown.visible = true
	skill1_cooldown.max_value = firewall_cooldown
	skill1_cooldown.value = firewall_cooldown

	firewall_timer.start()
	skill1_cooldown.visible = true
	
func _on_patch_cooldown_finished() -> void:
	patch_on_cooldown = false
	skill2_button.disabled = false

func _on_backup_server_cooldown_finished() -> void:
	backup_server_on_cooldown = false
	skill3_button.disabled = false
	skill3_cooldown.visible = false
	skill3_cooldown.value = 0
	update_skill3_locked()

func start_patch_cooldown() -> void:
	if patch_on_cooldown:
		return

	patch_on_cooldown = true
	skill2_button.disabled = true

	skill2_cooldown.visible = true
	skill2_cooldown.max_value = patch_cooldown
	skill2_cooldown.value = patch_cooldown

	patch_timer.start()

func start_backup_server_cooldown() -> void:
	if backup_server_on_cooldown:
		return

	backup_server_on_cooldown = true
	skill3_button.disabled = true
	skill3_locked.visible = false
	skill3_cooldown.visible = true
	skill3_cooldown.max_value = backup_server_cooldown
	skill3_cooldown.value = backup_server_cooldown
	backup_server_timer.start()
	
func trigger_shake():
	var camera = get_tree().get_first_node_in_group("camera")
	camera.trigger_shake()

func trigger_shell_tremor(intensity: float):
	var camera = get_tree().get_first_node_in_group("camera")
	camera.shell_tremor(intensity)

func move_camera(coords: Vector2):
	var camera = get_tree().get_first_node_in_group("camera")
	var camera_tween = create_tween()
	camera_tween.tween_property(camera, "position", coords, 1)

	# camera.position = coords
func show_card_category(category: int) -> void:
	# Non-sandbox cannot access Enemy
	if not Data.is_sandbox and category == CardCategory.ENEMY:
		category = CardCategory.TOWER

	if Data.is_vmmode and Data.vmmode_sentinels_disabled and category == CardCategory.SENTINEL:
		category = CardCategory.TOWER

	# Set visibility
	tower_cards_container.visible = category == CardCategory.TOWER
	sentinel_cards_container.visible = category == CardCategory.SENTINEL
	enemy_cards_container.visible = category == CardCategory.ENEMY and Data.is_sandbox

	# Update button based on which container is actually visible
	update_tower_enemies_button_texture()

func _on_tower_enemies_button_pressed() -> void:
	UISound.play_click()
	if Data.is_sandbox:
		if tower_cards_container.visible:
			show_card_category(CardCategory.SENTINEL)

		elif sentinel_cards_container.visible:
			show_card_category(CardCategory.ENEMY)

		elif enemy_cards_container.visible:
			show_card_category(CardCategory.TOWER)

	elif Data.is_vmmode and Data.vmmode_sentinels_disabled:
		pass

	else:
		if tower_cards_container.visible:
			show_card_category(CardCategory.SENTINEL)

		elif sentinel_cards_container.visible:
			show_card_category(CardCategory.TOWER)


#sandbox
func sandbox_spawn_enemy(enemy_enum: Data.Enemy):
	spawn_enemy.emit(enemy_enum)


func update_experience(experience: int, level: int, level_pool: float):
	$Control/TextureRect/PlayerCurrentStats/ExperienceBar.value = experience
	$Control/TextureRect/PlayerCurrentStats/ExperienceBar/LabelExp.text = str(level)
	$Control/TextureRect/PlayerCurrentStats/ExperienceBar.max_value = level_pool


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
		$Control/TextureRect/PlayerCurrentStats/HPBar.max_value = Data.max_health
		$Control/TextureRect/PlayerCurrentStats/HPBar.value = health

	update_server_load()

	
	print("Stats Updated: Money - " + str(money) + ", Health - " + str(health) + ", " + "Max Load - " + str(Data.currentserverload) + " / " + str(Data.maxserverload))


func update_wave_label() -> void:
	$Control/TextureRect/PlayerCurrentStats/WaveNum.text = "Wave " + str(Data.current_wave) + " /50"
	

func show_play_button(state: bool):
	$Control/TextureRect/HBoxContainer/WaveButton.visible = true
	Data.is_play_shown = state

func is_auto_enabled() -> bool:
	var auto_button = $Control/AutoLabel/AutoButton
	return auto_button.is_pressed()

func disable_auto():
	var auto_button = $Control/AutoLabel/AutoButton
	auto_button.button_pressed = false

func _on_auto_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UISound.play_click()
	else:
		UISound.play_close()

func _on_wave_button_pressed() -> void:
	UISound.play_click()
	start_wave.emit()


func _on_pause_button_pressed() -> void:
	UISound.play_click()
	$PauseMenu.visible = true
	get_tree().paused = true


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
		card.toggle_active()
		card.update_free_label()


func _on_stats_counter_button_pressed() -> void:
	UISound.play_click()
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
		if !Data.is_server_cyber_shown and Data.current_wave == 7:
			Data.is_server_cyber_shown = true
			Data.open_server_cyber.emit()

	else:
		$ServerUpgrade.visible = false
		$Control.visible = true
		is_shown = false

func _schedule_next_ad():
	if Data.active_adware <= 0:
		ad_timer.stop()
		return

	# Count towers that are not infected
	var available := 0
	for tower in get_tree().get_nodes_in_group("Towers"):
		if !tower.ad_active and !tower.ransomware_active:
			available += 1

	# Every tower already has an ad
	if available == 0:
		ad_timer.stop()
		return

	var ad_count: int = min(Data.active_adware, 10)
	var wait_time: float = 15.0 - (float(ad_count - 1) * 11.0 / 9.0)
	ad_timer.start(wait_time)

func _spawn_random_ad():
	if Data.active_adware <= 0:
		return

	var candidates := []

	for tower in get_tree().get_nodes_in_group("Towers"):
		if !tower.ad_active and !tower.ransomware_active:
			candidates.append(tower)

	if candidates.is_empty():
		_schedule_next_ad()
		return

	candidates.pick_random().show_ad()

	_schedule_next_ad()

func _schedule_next_ransomware():
	if Data.active_ransomware <= 0:
		ransomware_timer.stop()
		return

	var available := []

	for tower in get_tree().get_nodes_in_group("Towers"):
		if !tower.ransomware_active and !tower.ad_active:
			available.append(tower)

	if available.is_empty():
		ransomware_timer.stop()
		return

	ransomware_timer.start(20.0)
	
func _spawn_random_ransomware():
	if Data.active_ransomware <= 0:
		return

	var candidates := []

	for tower in get_tree().get_nodes_in_group("Towers"):
		if !tower.ransomware_active and !tower.ad_active:
			candidates.append(tower)

	if candidates.is_empty():
		return

	candidates.pick_random().ransomware_effect()
	_schedule_next_ransomware()

# SANDBOX MODE TO NANDITO NAKAKALITO NILIPAT KO SA PINAKA BABA CODES NG SANDBOX
func _on_maxed_lvl_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UISound.play_click()
		Data.is_maxed_lvl = true
		Data.before_player_level = Data.player_level
		Data.before_total_experience = Data.experience
		Data.player_level = 100
		Data.experience = 100
		update_experience(Data.experience, Data.player_level, Data.default_level_pool)
		server_pts_label.text = "∞"
	else:
		UISound.play_close()
		Data.is_maxed_lvl = false
		Data.player_level = Data.before_player_level
		Data.experience = Data.before_total_experience
		Data.server_points = Data.before_server_points
		update_experience(Data.experience, Data.player_level, Data.default_level_pool)


func _on_unli_money_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UISound.play_click()
		Data.is_unli_money = true
		Data.before_total_money = Data.money

		Data.money = 999999

	else:
		UISound.play_close()
		Data.is_unli_money = false
		Data.money = Data.before_total_money

		
func _on_unli_health_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UISound.play_click()
		Data.is_unli_health = true
		Data.before_total_health = Data.health
		Data.health = 999999

	else:
		UISound.play_close()
		Data.is_unli_health = false
		Data.health = Data.before_total_health

 
func _on_unli_senti_cap_toggled(toggled_on: bool) -> void: # UNLI SERVER CAPACITY TO
	if toggled_on:
		UISound.play_click()
		Data.is_unli_senti_cap = true
		Data.before_max_server_load = Data.maxserverload

		Data.maxserverload = 999999

	else:
		UISound.play_close()
		Data.is_unli_senti_cap = false
		Data.maxserverload = Data.before_max_server_load
	
	update_server_load()
	

func hide_pop(state: bool):
	$PopUp.visible = state

func is_pop_open() -> bool:
	return $PopUp.visible or $Scripture.visible or $SentinelPop.visible or $TowerPop.visible

func hide_pop2(state: bool):
	$Scripture.visible = state

func hide_pop3(state: bool):
	$SentinelPop.visible = state

func hide_pop4(state: bool):
	$TowerPop.visible = state

func play_sentinel_pop(sentinel: String):
	$SentinelPop.play_animation(sentinel)
	$SentinelPop/Info/TextureRect/AnimatedSprite2D.play(sentinel)


func play_scene(scene: String):
	$Cutscene.visible = true
	$Cutscene/Control/AnimationPlayer.play(scene)

func toggle_fade():
	$AnimationPlayer.play("overlay_fade")
	
func update_boss_hp(enemy: Data.Enemy, current_hp: int, max_hp: int):
	boss_hp_bar.visible = true
	boss_hp_bar.max_value = max_hp
	boss_hp_bar.value = current_hp
	boss_hp_amount.text = "%d/%d" % [current_hp, max_hp]

	match enemy:
		Data.Enemy.BOSS1:
			boss_name.text = "ILOVEYOU VIRUS"
		Data.Enemy.BOSS2:
			boss_name.text = "Conficker"
		Data.Enemy.BOSS3:
			boss_name.text = "WannaCry"
		Data.Enemy.BOSS4:
			boss_name.text = "NotPetya"
		Data.Enemy.BOSS5:
			boss_name.text = "MyDoom"


func _on_server_health_upgraded(new_max_health: float) -> void:
	update_stats(Data.money, Data.health)
	
func register_boss(boss_id: int, boss_name_text: String, current_hp: int, max_hp: int):
	# already assigned
	if boss_bar_assignments.has(boss_id):
		return

	# first free bar
	for bar in boss_bars:
		if bar.visible:
			continue

		bar.visible = true
		bar.max_value = max_hp
		bar.value = current_hp
		bar.get_node("bossname").text = boss_name_text
		bar.get_node("hpamount").text = "%d/%d" % [current_hp, max_hp]

		boss_bar_assignments[boss_id] = bar
		return
		
func update_boss_bar(boss_id: int, current_hp: int, max_hp: int):
	if !boss_bar_assignments.has(boss_id):
		return

	var bar = boss_bar_assignments[boss_id]

	bar.max_value = max_hp
	bar.value = current_hp
	bar.get_node("hpamount").text = "%d/%d" % [current_hp, max_hp]

func unregister_boss(boss_id: int):
	if !boss_bar_assignments.has(boss_id):
		return

	var bar = boss_bar_assignments[boss_id]
	bar.visible = false

	boss_bar_assignments.erase(boss_id)

	_reorder_boss_bars()

func _reorder_boss_bars():
	var remaining := []

	for id in boss_bar_assignments:
		remaining.append({
			"id": id,
			"bar": boss_bar_assignments[id]
		})

	# hide all bars
	for bar in boss_bars:
		bar.visible = false

	boss_bar_assignments.clear()

	# reuse bars from top
	for i in remaining.size():
		var old_bar = remaining[i]["bar"]
		var new_bar = boss_bars[i]

		new_bar.visible = true
		new_bar.max_value = old_bar.max_value
		new_bar.value = old_bar.value

		new_bar.get_node("bossname").text = old_bar.get_node("bossname").text
		new_bar.get_node("hpamount").text = old_bar.get_node("hpamount").text

		boss_bar_assignments[remaining[i]["id"]] = new_bar
		
func update_tower_enemies_button_texture() -> void:
	if tower_cards_container.visible:
		tower_enemies_button.texture_normal = tower_card_button_texture
	elif sentinel_cards_container.visible:
		tower_enemies_button.texture_normal = sentinel_card_button_texture
	elif enemy_cards_container.visible:
		tower_enemies_button.texture_normal = enemy_card_button_texture
		
signal signal_unlock_tower()
func pop_tower(tower_enum: Data.Tower, tower: String):
	# # for unlocking towers
	var tower_pop = get_tree().get_first_node_in_group("animate3")

	%Upgrade.selected_tower = tower_enum
	signal_unlock_tower.emit()
	tower_pop.play_animation(tower)
	unlock_tower_card(tower_enum)

func unlock_tower_card(tower_enum: Data.Tower) -> void:
	if tower_enum == Data.Tower.BACKUP_SERVER:
		return
	# Don't create a duplicate card
	for card in tower_cards_container.get_children():
		if card.id == tower_enum:
			return

	var tower_card = tower_card_scene.instantiate()
	tower_card.setup(tower_enum)

	# Find the correct position based on Data.Tower enum order
	var insert_index := 0

	for card in tower_cards_container.get_children():
		if card.id < tower_enum:
			insert_index += 1

	tower_cards_container.add_child(tower_card)
	tower_cards_container.move_child(tower_card, insert_index)

	tower_card.connect("press", tower_select)

func unlock_sentinel_card(sentinel_enum: Data.Sentinel) -> void:
	# Don't create a duplicate card
	for card in sentinel_cards_container.get_children():
		if card.id == sentinel_enum:
			return

	var sentinel_card = sentinel_card_scene.instantiate()
	sentinel_card.setup(sentinel_enum)

	# Find the correct position based on Data.Sentinel enum order
	var insert_index := 0

	for card in sentinel_cards_container.get_children():
		if card.id < sentinel_enum:
			insert_index += 1

	sentinel_cards_container.add_child(sentinel_card)
	sentinel_cards_container.move_child(sentinel_card, insert_index)

	sentinel_card.connect("press", sentinel_select)


func _on_skill_3_pressed() -> void:
	UISound.play_click()
	if backup_server_on_cooldown:
		return
	if Data.backup_server_placed:
		return
	tower_select(8)

func update_skill3_locked() -> void:
	skill3_locked.visible = Data.backup_server_placed and not backup_server_on_cooldown
	skill3_cooldown.visible = backup_server_on_cooldown
	if backup_server_on_cooldown:
		skill3_button.disabled = true
	else:
		skill3_button.disabled = false
		if Data.backup_server_placed:
			skill3_locked.visible = true
			skill3_cooldown.visible = false
