extends CanvasLayer

var tower_card_scene = preload("res://scenes/ui/tower_card_for_upgrades.tscn")

var upgrade1_level := 0
var upgrade2_level := 0
var upgrade3_level := 0
var upgrade4_level := 0
var upgrade5_level := 0
var upgrade6_level := 0

var selected_tower: Data.Tower = Data.Tower.BASIC


func _ready() -> void:
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$SentinelsContainer.add_child(tower_card)
	update_tier_buttons()


func set_selected_tower(tower_enum: Data.Tower) -> void:
	selected_tower = tower_enum

	$BigTowerName.text = Data.TOWER_DATA[tower_enum]['name']
	$BigPic.texture = load(Data.TOWER_DATA[tower_enum]['thumbnail'])

	$UpgradeButton.visible = true

	update_stat_label()
	update_upgrade_ui()


func update_stat_label() -> void:
	var data = Data.TOWER_DATA[selected_tower]

	$StatPanel/ScrollContainer/VBoxContainer/DamageContainer/DamagePic/DamageText.text = str(data['damage'])
	$StatPanel/ScrollContainer/VBoxContainer/SpeedContainer/SpeedPic/SpeedText.text = str(data['reload_time'])
	$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = str(data['range'])
	$StatPanel/ScrollContainer/VBoxContainer/CritRContainer/CritRPic/CritRText.text = str(data['crit rate']) + "%"
	$StatPanel/ScrollContainer/VBoxContainer/CritDContainer/CritDPic/CritDText.text = str(data['crit damage']) + "%"

	$UpgradePanel/Upgrade1/Upgrade1Label.text = data['upgrade1']
	$UpgradePanel/Upgrade2/Upgrade2Label.text = data['upgrade2']
	$UpgradePanel/Upgrade3/Upgrade3Label.text = data['upgrade3']
	$UpgradePanel/Upgrade4/Upgrade4Label.text = data['upgrade4']
	$UpgradePanel/Upgrade5/Upgrade5Label.text = data['upgrade5']
	$UpgradePanel/Upgrade6/Upgrade6Label.text = data['upgrade6']

	upgrade1_level = data['upgrade1level']
	upgrade2_level = data['upgrade2level']
	upgrade3_level = data['upgrade3level']
	upgrade4_level = data['upgrade4level']
	upgrade5_level = data['upgrade5level']
	upgrade6_level = data['upgrade6level']


func update_upgrade_ui() -> void:
	var data = Data.TOWER_DATA[selected_tower]

	var levels = [
		data['upgrade1level'],
		data['upgrade2level'],
		data['upgrade3level'],
		data['upgrade4level'],
		data['upgrade5level'],
		data['upgrade6level']
	]

	var upgrades = [
		$UpgradePanel/Upgrade1,
		$UpgradePanel/Upgrade2,
		$UpgradePanel/Upgrade3,
		$UpgradePanel/Upgrade4,
		$UpgradePanel/Upgrade5,
		$UpgradePanel/Upgrade6
	]

	for i in range(6):
		_set_upgrade_visual(upgrades[i], levels[i])


func _set_upgrade_visual(node: Node, level: int) -> void:
	var node_name_prefix = node.name

	var slots = ["a", "b", "c"]

	for i in range(3):
		var tex = "NotUpgraded.png"
		if i < level:
			tex = "Upgraded.png"

		var child_name = node_name_prefix + slots[i] 
		var child = node.get_node(child_name)
		if child:
			child.texture = load("res://graphics/upgrade/" + tex)


func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true
	$SentinelUpgradeUi.visible = false


func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false
	$SentinelUpgradeUi.visible = true


func _on_upgrade_button_pressed() -> void:
	$StatPanel/CurrentStat.text = $BigTowerName.text
	$VScrollBar.visible = false
	%SentinelsContainer.visible = false

	%BigPic.position.x -= 297
	$BigTowerName.visible = false
	$UpgradeButton.visible = false

	$StatPanel.visible = true
	$UpgradePanel.visible = true
	
	$StatPanel/AbilityPanel/Passive.text = Data.TOWER_DATA[selected_tower]['passive'] + ": " + Data.TOWER_DATA[selected_tower]['passive description'] 


func _on_back_btn_pressed() -> void:
	if %SentinelsContainer.visible == false:
		%SentinelsContainer.visible = true
		$VScrollBar.visible = true

		%BigPic.position.x += 297
		$BigTowerName.position.x += 297

		$UpgradeButton.visible = true
		$StatPanel.visible = false
		$UpgradePanel.visible = false
	else:
		get_tree().paused = false
		visible = false


func _on_stat_panel_left_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/stats.png")


func _on_stat_panel_right_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/ability.png")


func _on_upgrade_1_pressed() -> void:
	if upgrade1_level < 3:
		upgrade1_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade1level'] = upgrade1_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade1"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade1, upgrade1_level)
		update_tier_buttons()


func _on_upgrade_2_pressed() -> void:
	if upgrade2_level < 3:
		upgrade2_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade2level'] = upgrade2_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade2"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade2, upgrade2_level)
		update_tier_buttons()


func _on_upgrade_3_pressed() -> void:
	if upgrade3_level < 3:
		upgrade3_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade3level'] = upgrade3_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade3"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade3, upgrade3_level)
		update_tier_buttons()

func _on_upgrade_4_pressed() -> void:
	if upgrade4_level < 3:
		upgrade4_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade4level'] = upgrade4_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade4"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade4, upgrade4_level)
		update_tier_buttons()


func _on_upgrade_5_pressed() -> void:
	if upgrade5_level < 3:
		upgrade5_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade5level'] = upgrade5_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade5"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade5, upgrade5_level)
		update_tier_buttons()


func _on_upgrade_6_pressed() -> void:
	if upgrade6_level < 3:
		upgrade6_level += 1
		Data.TOWER_DATA[selected_tower]['upgrade6level'] = upgrade6_level
		apply_upgrade(
			Data.TOWER_DATA[selected_tower]["upgrade6"]
		)

		_set_upgrade_visual($UpgradePanel/Upgrade6, upgrade6_level)
		update_tier_buttons()


func apply_upgrade(upgrade_name: String) -> void:
	var amount = Data.UPGRADE_DATA[upgrade_name]

	match upgrade_name:
		"Damage":
			Data.TOWER_DATA[selected_tower]["damage"] += amount

		"Attack Speed":
			Data.TOWER_DATA[selected_tower]["reload_time"] -= amount

			# Prevent negative reload time
			if Data.TOWER_DATA[selected_tower]["reload_time"] < 0.1:
				Data.TOWER_DATA[selected_tower]["reload_time"] = 0.1

		"Range":
			Data.TOWER_DATA[selected_tower]["range"] += amount

		"Crit Rate":
			Data.TOWER_DATA[selected_tower]["crit rate"] += amount

		"Crit Damage":
			Data.TOWER_DATA[selected_tower]["crit damage"] += amount

	for tower in get_tree().get_nodes_in_group("towers"):
		tower.refresh_stats()
	update_stat_label()


func _on_tier_1_btn_pressed() -> void:
	$UpgradePanel/Upgrade1.visible = true
	$UpgradePanel/Upgrade2.visible = true
	$UpgradePanel/Upgrade3.visible = false
	$UpgradePanel/Upgrade4.visible = false
	$UpgradePanel/Upgrade5.visible = false
	$UpgradePanel/Upgrade6.visible = false
	$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierClicked.png")
	$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierUnclicked.png")
	$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierUnclicked.png")



func _on_tier_2_btn_pressed() -> void:
	if $UpgradePanel/Tier2Btn.disabled:
		return

	$UpgradePanel/Upgrade1.visible = false
	$UpgradePanel/Upgrade2.visible = false
	$UpgradePanel/Upgrade3.visible = true
	$UpgradePanel/Upgrade4.visible = true
	$UpgradePanel/Upgrade5.visible = false
	$UpgradePanel/Upgrade6.visible = false
	$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierUnclicked.png")
	$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierClicked.png")
	$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierUnclicked.png")

func _on_tier_3_btn_pressed() -> void:
	if $UpgradePanel/Tier3Btn.disabled:
		return

	$UpgradePanel/Upgrade1.visible = false
	$UpgradePanel/Upgrade2.visible = false
	$UpgradePanel/Upgrade3.visible = false
	$UpgradePanel/Upgrade4.visible = false
	$UpgradePanel/Upgrade5.visible = true
	$UpgradePanel/Upgrade6.visible = true
	$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierUnclicked.png")
	$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierUnclicked.png")
	$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierClicked.png")

func update_tier_buttons():
	# Tier 1 always available
	$UpgradePanel/Tier1Btn.disabled = false

	# Unlock Tier 2
	$UpgradePanel/Tier2Btn.disabled = !(
		upgrade1_level == 3 and
		upgrade2_level == 3
	)

	# Unlock Tier 3
	$UpgradePanel/Tier3Btn.disabled = !(
		upgrade3_level == 3 and
		upgrade4_level == 3
	)
