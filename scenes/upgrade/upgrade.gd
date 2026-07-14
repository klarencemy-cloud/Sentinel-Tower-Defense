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
	update_money_display()
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		%SentinelsContainer.add_child(tower_card)
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
	$StatPanel/ScrollContainer/VBoxContainer/SpeedContainer/SpeedPic/SpeedText.text = str(data['reload_time']) + "s"
	if selected_tower == Data.Tower.MORTAR:
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = str(data['explosion_radius'])
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/Range.text = "Explosion Radius"
	elif selected_tower == Data.Tower.QUARANTINE_CANNON:
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = "%s / %s" % [str(data['range']), str(data['explosion_radius'])]
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/Range.text = "Range / Radius"
	else:
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = str(data['range'])
		$StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/Range.text = "Range"
	$StatPanel/ScrollContainer/VBoxContainer/CritRContainer/CritRPic/CritRText.text = str(data['crit rate']) + "%"
	$StatPanel/ScrollContainer/VBoxContainer/CritDContainer/CritDPic/CritDText.text = str(data['crit damage']) + "%"

	$UpgradePanel/Upgrade1/Upgrade1Label.text = _format_upgrade_label(data['upgrade1'], 1, upgrade1_level)
	$UpgradePanel/Upgrade2/Upgrade2Label.text = _format_upgrade_label(data['upgrade2'], 2, upgrade2_level)
	$UpgradePanel/Upgrade3/Upgrade3Label.text = _format_upgrade_label(data['upgrade3'], 3, upgrade3_level)
	$UpgradePanel/Upgrade4/Upgrade4Label.text = _format_upgrade_label(data['upgrade4'], 4, upgrade4_level)
	$UpgradePanel/Upgrade5/Upgrade5Label.text = _format_upgrade_label(data['upgrade5'], 5, upgrade5_level)
	$UpgradePanel/Upgrade6/Upgrade6Label.text = _format_upgrade_label(data['upgrade6'], 6, upgrade6_level)

	_set_upgrade_amount_label(1, data['upgrade1'], data.get('upgrade1amount', 0))
	_set_upgrade_amount_label(2, data['upgrade2'], data.get('upgrade2amount', 0))
	_set_upgrade_amount_label(3, data['upgrade3'], data.get('upgrade3amount', 0))
	_set_upgrade_amount_label(4, data['upgrade4'], data.get('upgrade4amount', 0))
	_set_upgrade_amount_label(5, data['upgrade5'], data.get('upgrade5amount', 0))
	_set_upgrade_amount_label(6, data['upgrade6'], data.get('upgrade6amount', 0))

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


func update_money_display() -> void:
	$UpgradePanel/Money.text = str(Data.money)


func _get_upgrade_cost(slot_index: int, current_level: int) -> int:
	var tower_data = Data.TOWER_DATA[selected_tower]
	var cost_key = "upgrade%dcost" % slot_index
	if tower_data.has(cost_key):
		var costs = tower_data[cost_key]
		if typeof(costs) == TYPE_ARRAY and current_level < costs.size():
			return int(costs[current_level])
	return 0


func _format_upgrade_label(upgrade_name: String, slot_index: int, current_level: int) -> String:
	if current_level >= 3:
		return "%s (Max)" % upgrade_name

	var cost = _get_upgrade_cost(slot_index, current_level)
	if cost > 0:
		return "%s - $%d" % [upgrade_name, cost]
	return upgrade_name


func _format_upgrade_amount(upgrade_name: String, amount: Variant) -> String:
	if upgrade_name == "Attack Speed":
		return "-%s" % str(amount)
	return "+%s" % str(amount)


func _set_upgrade_amount_label(slot_index: int, upgrade_name: String, amount: Variant) -> void:
	var label = get_node_or_null("UpgradePanel/Upgrade%d/Upgrade%dAmount" % [slot_index, slot_index])
	if label:
		label.text = _format_upgrade_amount(upgrade_name, amount)


func _try_purchase_upgrade(slot_index: int) -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]
	var level_key = "upgrade%dlevel" % slot_index
	var upgrade_key = "upgrade%d" % slot_index
	var current_level = int(tower_data.get(level_key, 0))

	if current_level >= 3:
		return

	var cost = _get_upgrade_cost(slot_index, current_level)
	if not Data.is_unli_money and Data.money < cost:
		return

	if not Data.is_unli_money:
		Data.money -= cost

	current_level += 1
	tower_data[level_key] = current_level

	match slot_index:
		1:
			upgrade1_level = current_level
		2:
			upgrade2_level = current_level
		3:
			upgrade3_level = current_level
		4:
			upgrade4_level = current_level
		5:
			upgrade5_level = current_level
		6:
			upgrade6_level = current_level

	apply_upgrade(tower_data[upgrade_key])
	_set_upgrade_visual(get_node("UpgradePanel/Upgrade%d" % slot_index), current_level)
	update_tier_buttons()
	update_ability_panel()
	update_money_display()


func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true
	$SentinelUpgradeUi.visible = false


func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false
	$SentinelUpgradeUi.visible = true


func _on_upgrade_button_pressed() -> void:
	update_stat_label()
	update_upgrade_ui()
	$StatPanel/CurrentStat.text = $BigTowerName.text
	%SentinelsContainer.visible = false

	%BigPic.position.x -= 430
	$BigTowerName.visible = false
	$UpgradeButton.visible = false

	$StatPanel.visible = true
	$UpgradePanel.visible = true
	
	if Data.TOWER_DATA[selected_tower].has("passive"):
		$StatPanel/AbilityPanel/VBoxContainer/Passive.text = Data.TOWER_DATA[selected_tower]["passive"] + "(Passive): " + Data.TOWER_DATA[selected_tower]['passive description']
	else:
		$StatPanel/AbilityPanel/VBoxContainer/Passive.text = "This tower has no passive skill!"
	update_ability_panel()

func _on_stat_panel_left_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/stats.png")
	$StatPanel/AbilityPanel.visible = false
	$StatPanel/ScrollContainer/VBoxContainer.visible = true

func _on_stat_panel_right_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/ability.png")
	$StatPanel/AbilityPanel.visible = true
	$StatPanel/ScrollContainer/VBoxContainer.visible = false

func _on_upgrade_1_pressed() -> void:
	_try_purchase_upgrade(1)


func _on_upgrade_2_pressed() -> void:
	_try_purchase_upgrade(2)


func _on_upgrade_3_pressed() -> void:
	_try_purchase_upgrade(3)

func _on_upgrade_4_pressed() -> void:
	_try_purchase_upgrade(4)


func _on_upgrade_5_pressed() -> void:
	_try_purchase_upgrade(5)


func _on_upgrade_6_pressed() -> void:
	_try_purchase_upgrade(6)


func apply_upgrade(upgrade_name: String) -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]
	var amount = 0

	# Find which upgrade slot matches this upgrade_name for the selected tower
	for i in range(1, 7):
		var key = "upgrade%d" % i
		var amt_key = "upgrade%damount" % i
		if tower_data.has(key) and tower_data[key] == upgrade_name:
			amount = tower_data.get(amt_key, 0)
			break

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

		"Explosion Radius":
			Data.TOWER_DATA[selected_tower]["explosion_radius"] += amount

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

	# Update tier ability unlocked flags in tower data (persist unlocks)
	if Data.TOWER_DATA.has(selected_tower):
		var d = Data.TOWER_DATA[selected_tower]
		if d.has("tier1abilityunlocked"):
			d['tier1abilityunlocked'] = (d['upgrade1level'] == 3 and d['upgrade2level'] == 3)
		if d.has("tier2abilityunlocked"):
			d['tier2abilityunlocked'] = (d['upgrade3level'] == 3 and d['upgrade4level'] == 3)
		if d.has("tier3abilityunlocked"):
			d['tier3abilityunlocked'] = (d['upgrade5level'] == 3 and d['upgrade6level'] == 3)

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
	
func update_ability_panel() -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]

	for i in range(3):
		var tier = i + 1
		var label = get_node("StatPanel/AbilityPanel/VBoxContainer/Tier%dAbility" % tier)

		var unlocked := false
		var unlock_text := ""
		var ability := ""
		var desc := ""

		if tower_data.has("tier%dability" % tier):
			ability = tower_data["tier%dability" % tier]
			desc = tower_data["tier%dabilitydesc" % tier]

		match tier:
			1:
				if tower_data.has("tier1ability"):
					unlocked = tower_data["upgrade1level"] == 3 and tower_data["upgrade2level"] == 3
					unlock_text = "Purchase all tier 1 upgrades to unlock this ability."
				else:
					unlock_text = "No Tier 1 Ability!"

			2:
				if tower_data.has("tier2ability"):
					unlocked = tower_data["upgrade3level"] == 3 and tower_data["upgrade4level"] == 3
					unlock_text = "Purchase all tier 2 upgrades to unlock this ability."
				else:
					unlock_text = "No Tier 2 Ability!"

			3:
				if tower_data.has("tier3ability"):
					unlocked = tower_data["upgrade5level"] == 3 and tower_data["upgrade6level"] == 3
					unlock_text = "Purchase all tier 3 upgrades to unlock this ability."
				else:
					unlock_text = "No Tier 3 Ability!"

		if unlocked:
			label.text = "%s: %s" % [ability, desc]
		else:
			label.text = unlock_text


func _on_back_btn_pressed() -> void:
	if %SentinelsContainer.visible == true:
		get_tree().paused = false
		visible = false
	else:
		%SentinelsContainer.visible = true

		%BigPic.position.x += 430
		$BigTowerName.visible = true
		$UpgradeButton.visible = true

		$StatPanel.visible = false
		$UpgradePanel.visible = false
		$StatPanel/AbilityPanel.visible = false
		$StatPanel.texture = load("res://graphics/container/stats.png")
		$StatPanel/ScrollContainer/VBoxContainer.visible = true
