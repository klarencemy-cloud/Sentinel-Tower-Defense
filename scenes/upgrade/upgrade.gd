extends CanvasLayer

var tower_card_scene = preload("res://scenes/ui/tower_card_for_upgrades.tscn")
var sentinel_card_scene = preload("res://scenes/ui/sentinel_card.tscn")

var upgrade1_level := 0
var upgrade2_level := 0
var upgrade3_level := 0
var upgrade4_level := 0
var upgrade5_level := 0
var upgrade6_level := 0

var selected_tower: Data.Tower
var sentinel_roll_thumbnails: Array = []
var sentinel_roll_active := false

func _ready() -> void:
	update_money_display()
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		%SentinelsContainer.add_child(tower_card)

	for sentinel_enum in Data.Sentinel.values():
		var sentinel_card = sentinel_card_scene.instantiate()
		sentinel_card.setup(sentinel_enum)
		$SentinelStuff/ScrollContainer/RealSentinelContainer.add_child(sentinel_card)
	
	sentinel_roll_thumbnails = _build_sentinel_roll_thumbnails()
	$SentinelStuff/Rollbtn.connect("pressed", Callable(self, "_on_Rollbtn_pressed"))
	update_tier_buttons()
	
func set_selected_tower(tower_enum: Data.Tower) -> void:
	selected_tower = tower_enum

	$TextureRect/BigTowerName.text = Data.TOWER_DATA[tower_enum]['name']
	%BigPic.texture = load(Data.TOWER_DATA[tower_enum]['thumbnail'])

	$TextureRect/UpgradeButton.visible = true
	var upgradeable: bool = bool(Data.TOWER_DATA[tower_enum].get("upgradeable", true))
	if upgradeable:
		$TextureRect/UpgradeButton/Label.text = "Upgrade"
	else:
		$TextureRect/UpgradeButton/Label.text = "Not Upgradeable"
	update_stat_label()
	update_upgrade_ui()
	update_tier_buttons()
	_set_tier_view(1)


func update_stat_label() -> void:
	var data = Data.TOWER_DATA[selected_tower]
	if !data.has("upgrade1"):
		$TextureRect/UpgradePanel.visible = false
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/DamageContainer/DamagePic/DamageText.text = "-"
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/SpeedContainer/SpeedPic/SpeedText.text = "-"
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = "-"
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/CritRContainer/CritRPic/CritRText.text = "-"
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/CritDContainer/CritDPic/CritDText.text = "-"
		return
	
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer/DamageContainer/DamagePic/DamageText.text = str(data['damage'])
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer/SpeedContainer/SpeedPic/SpeedText.text = str(data['reload_time']) + "s"
	if selected_tower == Data.Tower.QUARANTINE_CANNON:
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = "%s / %s" % [str(data['range']), str(data['explosion_radius'])]
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/Range.text = "Range / Radius"
	else:
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/RangeText.text = str(data['range'])
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer/RangeContainer/RangePic/Range.text = "Range"
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer/CritRContainer/CritRPic/CritRText.text = str(data['crit rate']) + "%"
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer/CritDContainer/CritDPic/CritDText.text = str(data['crit damage']) + "%"

	upgrade1_level = int(data.get('upgrade1level', 0))
	upgrade2_level = int(data.get('upgrade2level', 0))
	upgrade3_level = int(data.get('upgrade3level', 0))
	upgrade4_level = int(data.get('upgrade4level', 0))
	upgrade5_level = int(data.get('upgrade5level', 0))
	upgrade6_level = int(data.get('upgrade6level', 0))

	$TextureRect/UpgradePanel/Upgrade1/Upgrade1Label.text = _format_upgrade_label(data['upgrade1'], 1, upgrade1_level)
	$TextureRect/UpgradePanel/Upgrade2/Upgrade2Label.text = _format_upgrade_label(data['upgrade2'], 2, upgrade2_level)
	$TextureRect/UpgradePanel/Upgrade3/Upgrade3Label.text = _format_upgrade_label(data['upgrade3'], 3, upgrade3_level)
	$TextureRect/UpgradePanel/Upgrade4/Upgrade4Label.text = _format_upgrade_label(data['upgrade4'], 4, upgrade4_level)
	$TextureRect/UpgradePanel/Upgrade5/Upgrade5Label.text = _format_upgrade_label(data['upgrade5'], 5, upgrade5_level)
	$TextureRect/UpgradePanel/Upgrade6/Upgrade6Label.text = _format_upgrade_label(data['upgrade6'], 6, upgrade6_level)

	_set_upgrade_amount_label(1, data['upgrade1'], data.get('upgrade1amount', 0), upgrade1_level)
	_set_upgrade_amount_label(2, data['upgrade2'], data.get('upgrade2amount', 0), upgrade2_level)
	_set_upgrade_amount_label(3, data['upgrade3'], data.get('upgrade3amount', 0), upgrade3_level)
	_set_upgrade_amount_label(4, data['upgrade4'], data.get('upgrade4amount', 0), upgrade4_level)
	_set_upgrade_amount_label(5, data['upgrade5'], data.get('upgrade5amount', 0), upgrade5_level)
	_set_upgrade_amount_label(6, data['upgrade6'], data.get('upgrade6amount', 0), upgrade6_level)


func update_upgrade_ui() -> void:
	var data = Data.TOWER_DATA[selected_tower]

	if !data.get("has_upgrades", true):
		return

	var levels = [
		int(data.get("upgrade1level", 0)),
		int(data.get("upgrade2level", 0)),
		int(data.get("upgrade3level", 0)),
		int(data.get("upgrade4level", 0)),
		int(data.get("upgrade5level", 0)),
		int(data.get("upgrade6level", 0))
	]

	var upgrades = [
		$TextureRect/UpgradePanel/Upgrade1,
		$TextureRect/UpgradePanel/Upgrade2,
		$TextureRect/UpgradePanel/Upgrade3,
		$TextureRect/UpgradePanel/Upgrade4,
		$TextureRect/UpgradePanel/Upgrade5,
		$TextureRect/UpgradePanel/Upgrade6
		
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
	$TextureRect/UpgradePanel/Money.text = str(Data.money)


func _get_upgrade_cost(slot_index: int, current_level: int) -> int:
	var tower_data = Data.TOWER_DATA[selected_tower]
	var cost_key = "upgrade%dcost" % slot_index
	if tower_data.has(cost_key):
		var costs = tower_data[cost_key]
		if typeof(costs) == TYPE_ARRAY and current_level < costs.size():
			return int(costs[current_level])
	return 0


func _get_upgrade_amount_for_level(amount: Variant, level: int) -> Variant:
	if typeof(amount) == TYPE_ARRAY:
		if level < 0:
			level = 0
		elif level >= amount.size():
			level = amount.size() - 1
		return amount[level]
	return amount


func _format_upgrade_label(upgrade_name: String, slot_index: int, current_level: int) -> String:
	if current_level >= 3:
		return "%s (Max)" % upgrade_name

	var cost = _get_upgrade_cost(slot_index, current_level)
	if cost > 0:
		return "%s - $%d" % [upgrade_name, cost]
	return upgrade_name


func _format_upgrade_amount(upgrade_name: String, amount: Variant) -> String:
	if typeof(amount) == TYPE_ARRAY:
		amount = _get_upgrade_amount_for_level(amount, 0)
	if upgrade_name == "Attack Speed":
		return "-%s" % str(amount)
	return "+%s" % str(amount)


func _set_upgrade_amount_label(slot_index: int, upgrade_name: String, amount: Variant, current_level: int) -> void:
	var label = get_node_or_null("TextureRect/UpgradePanel/Upgrade%d/Upgrade%dAmount" % [slot_index, slot_index])
	if label:
		var display_amount = _get_upgrade_amount_for_level(amount, current_level)
		label.text = _format_upgrade_amount(upgrade_name, display_amount)


func _try_purchase_upgrade(slot_index: int) -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]
	if !tower_data.has("upgrade1"):
		return
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

	# apply_upgrade(tower_data[upgrade_key])
	apply_upgrade(slot_index)
	_set_upgrade_visual(get_node("TextureRect/UpgradePanel/Upgrade%d" % slot_index), current_level)
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
	if !Data.TOWER_DATA[selected_tower].has("upgrade1"):
		return
	update_upgrade_ui()
	update_tier_buttons()
	_set_tier_view(1)
	$TextureRect/StatPanel/CurrentStat.text = $TextureRect/BigTowerName.text
	%SentinelsContainer.visible = false

	%BigPic.position.x -= 340
	$TextureRect/BigTowerName.visible = false
	$TextureRect/UpgradeButton.visible = false

	$TextureRect/StatPanel.visible = true
	$TextureRect/UpgradePanel.visible = true
	
	if Data.TOWER_DATA[selected_tower].has("passive"):
		$TextureRect/StatPanel/AbilityPanel/VBoxContainer/Passive.text = Data.TOWER_DATA[selected_tower]["passive"] + "(Passive): " + Data.TOWER_DATA[selected_tower]['passive description']
	else:
		$TextureRect/StatPanel/AbilityPanel/VBoxContainer/Passive.text = "This tower has no passive skill!"
	update_ability_panel()

func _on_stat_panel_left_pressed() -> void:
	$TextureRect/StatPanel/AbilityPanel.visible = false
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer.visible = true

func _on_stat_panel_right_pressed() -> void:
	$TextureRect/StatPanel/AbilityPanel.visible = true
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer.visible = false

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


func apply_upgrade(slot_index: int) -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]
	var key = "upgrade%d" % slot_index
	var amt_key = "upgrade%damount" % slot_index
	var level_key = "upgrade%dlevel" % slot_index
	var upgrade_name = tower_data.get(key, "")
	var amount = tower_data.get(amt_key, 0)
	var level = int(tower_data.get(level_key, 0))
	amount = _get_upgrade_amount_for_level(amount, level - 1)

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


func _set_tier_view(tier: int) -> void:
	var panel = $TextureRect/UpgradePanel
	for upgrade_name in ["Upgrade1", "Upgrade2", "Upgrade3", "Upgrade4", "Upgrade5", "Upgrade6"]:
		panel.get_node(upgrade_name).visible = false

	match tier:
		1:
			panel.get_node("Upgrade1").visible = true
			panel.get_node("Upgrade2").visible = true
		2:
			panel.get_node("Upgrade3").visible = true
			panel.get_node("Upgrade4").visible = true
		3:
			panel.get_node("Upgrade5").visible = true
			panel.get_node("Upgrade6").visible = true

	panel.get_node("Tier1Btn").texture_normal = load("res://graphics/buttons/1stTier%s.png" % ("Clicked" if tier == 1 else "Unclicked"))
	panel.get_node("Tier2Btn").texture_normal = load("res://graphics/buttons/2ndTier%s.png" % ("Clicked" if tier == 2 else "Unclicked"))
	panel.get_node("Tier3Btn").texture_normal = load("res://graphics/buttons/3rdTier%s.png" % ("Clicked" if tier == 3 else "Unclicked"))

func _on_tier_1_btn_pressed() -> void:
	_set_tier_view(1)

func _on_tier_2_btn_pressed() -> void:
	if $TextureRect/UpgradePanel/Tier2Btn.disabled:
		return
	_set_tier_view(2)

func _on_tier_3_btn_pressed() -> void:
	if $TextureRect/UpgradePanel/Tier3Btn.disabled:
		return
	_set_tier_view(3)

func update_tier_buttons():
	$TextureRect/UpgradePanel/Tier1Btn.disabled = false

	var tier1_unlocked := true
	var tier2_unlocked := false

	if Data.TOWER_DATA.has(selected_tower):
		var d = Data.TOWER_DATA[selected_tower]
		upgrade1_level = int(d.get('upgrade1level', 0))
		upgrade2_level = int(d.get('upgrade2level', 0))
		upgrade3_level = int(d.get('upgrade3level', 0))
		upgrade4_level = int(d.get('upgrade4level', 0))
		upgrade5_level = int(d.get('upgrade5level', 0))
		upgrade6_level = int(d.get('upgrade6level', 0))

		tier1_unlocked = (upgrade1_level == 3 and upgrade2_level == 3)
		tier2_unlocked = (upgrade3_level == 3 and upgrade4_level == 3)

		if d.has('tier1abilityunlocked'):
			d['tier1abilityunlocked'] = tier1_unlocked
		if d.has('tier2abilityunlocked'):
			d['tier2abilityunlocked'] = tier2_unlocked
		if d.has('tier3abilityunlocked'):
			d['tier3abilityunlocked'] = (upgrade5_level == 3 and upgrade6_level == 3)

	$TextureRect/UpgradePanel/Tier2Btn.disabled = !tier1_unlocked
	$TextureRect/UpgradePanel/Tier3Btn.disabled = !tier2_unlocked
	
func update_ability_panel() -> void:
	var tower_data = Data.TOWER_DATA[selected_tower]

	for i in range(3):
		var tier = i + 1
		var label = get_node("TextureRect/StatPanel/AbilityPanel/VBoxContainer/Tier%dAbility" % tier)

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

func _build_sentinel_roll_thumbnails() -> Array:
	var textures: Array = []
	for sentinel_data in Data.SENTINEL_DATA.values():
		if sentinel_data.has("thumbnail"):
			var thumbnail_path = sentinel_data["thumbnail"]
			var texture = load(thumbnail_path)
			if texture:
				textures.append(texture)
	return textures

func _on_Rollbtn_pressed() -> void:
	if sentinel_roll_active:
		return
	if sentinel_roll_thumbnails.size() == 0:
		return

	sentinel_roll_active = true
	$SentinelStuff/Rollbtn.disabled = true
	await _animate_sentinel_roll()
	$SentinelStuff/Rollbtn.disabled = false
	sentinel_roll_active = false

func _animate_sentinel_roll() -> void:
	var duration = 3.0
	var interval = 0.08
	var elapsed = 0.0
	var sentinel_node = $SentinelStuff/SentinelRoll/Sentinel

	sentinel_node.modulate = Color(0, 0, 0, 1)

	while elapsed < duration:
		var random_texture = sentinel_roll_thumbnails[randi() % sentinel_roll_thumbnails.size()]
		sentinel_node.texture = random_texture
		await get_tree().create_timer(interval).timeout
		elapsed += interval

	var final_texture = sentinel_roll_thumbnails[randi() % sentinel_roll_thumbnails.size()]
	sentinel_node.texture = final_texture
	sentinel_node.modulate = Color(1, 1, 1, 1)

func _on_back_btn_pressed() -> void:
	if %SentinelsContainer.visible == true:
		get_tree().paused = false
		visible = false
	else:
		%SentinelsContainer.visible = true

		%BigPic.position.x += 340
		$TextureRect/BigTowerName.visible = true
		$TextureRect/UpgradeButton.visible = true

		$TextureRect/StatPanel.visible = false
		$TextureRect/UpgradePanel.visible = false
		$TextureRect/StatPanel/AbilityPanel.visible = false
		$TextureRect/StatPanel/ScrollContainer/VBoxContainer.visible = true


func _on_tower_btn_pressed() -> void:
	$TextureRect/ScrollContainer.visible = true
	$SentinelStuff.visible = false

func _on_sentinel_btn_pressed() -> void:
	$TextureRect/ScrollContainer.visible = false
	$TextureRect/UpgradeButton.visible = false
	%BigPic.visible = false
	$TextureRect/BigTowerName.visible = false
	$TextureRect/StatPanel.visible = false
	$TextureRect/UpgradePanel.visible = false
	$SentinelStuff.visible = true
	$SentinelStuff/SentinelRoll.visible = true


func _on_sentinel_list_pressed() -> void:
	$SentinelStuff/SentinelRoll.visible = false
	$SentinelStuff/ScrollContainer.visible = true
