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

# Scroll dragging
var scroll_dragging := false
var scroll_drag_start := Vector2.ZERO
var scroll_start_position := Vector2.ZERO
var active_scroll: ScrollContainer = null

const DRAG_THRESHOLD := 10.0

func _ready() -> void:
	var ui = get_tree().get_first_node_in_group("UI")
	ui.signal_unlock_tower.connect(_on_unlock_pressed)
	visibility_changed.connect(_on_visibility_changed)
	update_money_display()
	for tower_enum in Data.Tower.values():
		if tower_enum == Data.Tower.BACKUP_SERVER:
			continue
		if not Data.TOWER_DATA[tower_enum]["name"] == "PATCH":
			var tower_card = tower_card_scene.instantiate()
			tower_card.setup(tower_enum)
			%SentinelsContainer.add_child(tower_card)


	for sentinel_enum in Data.Sentinel.values():
		var sentinel_card = sentinel_card_scene.instantiate()

		sentinel_card.setup(sentinel_enum)

		var sentinel_data = Data.SENTINEL_DATA[sentinel_enum]

		var image: TextureRect = sentinel_card.get_node("TextureRect/TextureRect")
		var locked_image: TextureRect = sentinel_card.get_node("TextureRect/locked")
		var label: Label = sentinel_card.get_node("TextureRect/Label")

		# if Data.is_sandbox:
		# 	# Sandbox: all sentinels are treated as unlocked
		# 	locked_image.visible = false
		# 	image.modulate = Color.WHITE
		# 	label.text = sentinel_data.get("name", "")
		# else:
			# Normal mode: use the actual unlock status
		var is_unlocked: bool = sentinel_data.get("isUnlocked", false)

		if is_unlocked:
			locked_image.visible = false
			image.modulate = Color.WHITE
			label.text = sentinel_data.get("name", "")
		else:
			locked_image.visible = true
			image.modulate = Color.BLACK
			label.text = "???"

		$SentinelStuff/ScrollContainer/RealSentinelContainer.add_child(sentinel_card)
		sentinel_card.press.connect(change_info)
	sentinel_roll_thumbnails = _build_sentinel_roll_thumbnails()
	_refresh_core_labels()
	update_tier_buttons()

func _on_visibility_changed() -> void:
	if visible:
		update_money_display()


func set_selected_tower(tower_enum: Data.Tower) -> void:
	selected_tower = tower_enum

	var tower_data: Dictionary = Data.TOWER_DATA[tower_enum]

	$TextureRect/BigTowerName.text = tower_data["name"]
	%BigPic.texture = load(tower_data["thumbnail"])

	# if Data.is_sandbox:
	# 	# Sandbox: everything is unlocked
	# 	%BigPic.modulate = Color(1, 1, 1, 1)
	# 	$TextureRect/BigTowerName.text = tower_data["name"]
	# 	$TextureRect/UpgradeButton.visible = true
	# 	$TextureRect/BigTowerName.visible = true
	# 	%BigPic.visible = true
	# 	$TextureRect/Unlock.visible = false
	# 	$SentinelStuff/Rollbtn.visible = false

	# else:
		# Normal mode
	var is_unlocked: bool = bool(tower_data.get("isUnlocked", false))

	if !is_unlocked:
		# LOCKED
		%BigPic.modulate = Color(0, 0, 0, 0.5)
		%BigPic.visible = true
		$TextureRect/BigTowerName.text = "???"
		$TextureRect/UpgradeButton.visible = false
		$TextureRect/BigTowerName.visible = true

		_update_unlock_button()

	else:
		# UNLOCKED
		%BigPic.visible = true
		%BigPic.modulate = Color(1, 1, 1, 1)
		$TextureRect/BigTowerName.text = tower_data["name"]
		$TextureRect/UpgradeButton.visible = true
		$TextureRect/BigTowerName.visible = true
		$TextureRect/Unlock.visible = false

	var upgradeable: bool = bool(tower_data.get("upgradeable", true))

	if upgradeable:
		$TextureRect/UpgradeButton/Label.text = "Upgrade"
	else:
		$TextureRect/UpgradeButton/Label.text = "Not Upgradeable"

	update_stat_label()
	update_upgrade_ui()
	update_tier_buttons()
	_set_tier_view(1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return

		if event.pressed:
			var mouse_pos := get_viewport().get_mouse_position()

			var tower_scroll := $TextureRect/ScrollContainer
			var sentinel_scroll := $SentinelStuff/ScrollContainer

			if tower_scroll.visible and tower_scroll.get_global_rect().has_point(mouse_pos):
				active_scroll = tower_scroll
			elif sentinel_scroll.visible and sentinel_scroll.get_global_rect().has_point(mouse_pos):
				active_scroll = sentinel_scroll
			else:
				active_scroll = null

			if active_scroll:
				scroll_dragging = false
				scroll_drag_start = mouse_pos
				scroll_start_position = Vector2(
					active_scroll.scroll_horizontal,
					active_scroll.scroll_vertical
				)

		else:
			scroll_dragging = false
			active_scroll = null

	elif event is InputEventMouseMotion:
		if active_scroll == null:
			return

		var mouse_pos := get_viewport().get_mouse_position()
		var delta := mouse_pos - scroll_drag_start

		if !scroll_dragging:
			if delta.length() < DRAG_THRESHOLD:
				return

			scroll_dragging = true

		active_scroll.scroll_horizontal = int(
			scroll_start_position.x - delta.x
		)

		active_scroll.scroll_vertical = int(
			scroll_start_position.y - delta.y
		)
		
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
	if Data.is_unli_money:
		$TextureRect/UpgradePanel/Money.text = "∞"
	else:
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
	if Data.is_vmmode:
		return
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
	var save = get_tree().get_first_node_in_group("save")
	if !Data.is_sandbox:
		if save:
			save.save_game()

func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true
	$SentinelUpgradeUi.visible = false


func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false
	$SentinelUpgradeUi.visible = true


func _on_upgrade_button_pressed() -> void:
	UISound.play_click()
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
	UISound.play_click()
	$TextureRect/StatPanel/AbilityPanel.visible = false
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer.visible = true

func _on_stat_panel_right_pressed() -> void:
	UISound.play_click()
	$TextureRect/StatPanel/AbilityPanel.visible = true
	$TextureRect/StatPanel/ScrollContainer/VBoxContainer.visible = false

func _on_upgrade_1_pressed() -> void:
	UISound.play_click()
	_try_purchase_upgrade(1)


func _on_upgrade_2_pressed() -> void:
	UISound.play_click()
	_try_purchase_upgrade(2)


func _on_upgrade_3_pressed() -> void:
	UISound.play_click()
	_try_purchase_upgrade(3)

func _on_upgrade_4_pressed() -> void:
	UISound.play_click()
	_try_purchase_upgrade(4)


func _on_upgrade_5_pressed() -> void:
	UISound.play_click()
	_try_purchase_upgrade(5)


func _on_upgrade_6_pressed() -> void:
	UISound.play_click()
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
	UISound.play_click()
	_set_tier_view(1)

func _on_tier_2_btn_pressed() -> void:
	if $TextureRect/UpgradePanel/Tier2Btn.disabled:
		return
	UISound.play_click()
	_set_tier_view(2)

func _on_tier_3_btn_pressed() -> void:
	if $TextureRect/UpgradePanel/Tier3Btn.disabled:
		return
	UISound.play_click()
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
	# ALL sentinels are included in the animation.
	# This means already-unlocked sentinels can still appear
	# while the roll is spinning.
	sentinel_roll_thumbnails.clear()

	for sentinel_enum in Data.Sentinel.values():
		var sentinel_data = Data.SENTINEL_DATA[sentinel_enum]

		if sentinel_data.has("thumbnail"):
			var texture = load(sentinel_data["thumbnail"])

			if texture:
				sentinel_roll_thumbnails.append(texture)

	return sentinel_roll_thumbnails


func _get_locked_sentinels() -> Array:
	return Data.get_locked_sentinels()


func _refresh_core_labels() -> void:
	var core_inventory: Label = $SentinelStuff/Core/CoreInventory
	var core_requirement: Label = $SentinelStuff/Core/CoreRequirement

	core_inventory.text = "%d CORES" % Data.sentinel_cores

	if _get_locked_sentinels().is_empty():
		core_requirement.text = "All Sentinels Unlocked"
		$SentinelStuff/Rollbtn.disabled = true
	else:
		var cost: int = Data.get_sentinel_roll_cost()
		core_requirement.text = "Core Per Roll: %d Core%s" % [cost, "" if cost == 1 else "s"]
		$SentinelStuff/Rollbtn.disabled = false


func _animate_sentinel_roll(locked_sentinels: Array) -> void:
	var duration := 3.0
	var interval := 0.08
	var elapsed := 0.0

	var sentinel_node: TextureRect = $SentinelStuff/SentinelRoll/Sentinel

	# Start black
	sentinel_node.modulate = Color(0, 0, 0, 1)


	# ROLLING ANIMATION

	# ALL sentinels appears during animation
	while elapsed < duration:
		var random_index := randi() % sentinel_roll_thumbnails.size()
		sentinel_node.texture = sentinel_roll_thumbnails[random_index]

		await get_tree().create_timer(interval).timeout
		elapsed += interval


	# FINAL RESULT
	
	# Only choose from currently LOCKED sentinels.
	var chosen_index := randi() % locked_sentinels.size()
	var chosen_enum: Data.Sentinel = locked_sentinels[chosen_index]

	var chosen_data = Data.SENTINEL_DATA[chosen_enum]
	var chosen_texture = load(chosen_data["thumbnail"])

	# Show the winning sentinel
	sentinel_node.texture = chosen_texture
	sentinel_node.modulate = Color(1, 1, 1, 1)

	#unlocks sentinel
	Data.SENTINEL_DATA[chosen_enum]["isUnlocked"] = true
	
	
	_update_sentinel_card_visual(chosen_enum)
	
	# Add the newly unlocked sentinel to the main game UI
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.unlock_sentinel_card(chosen_enum)
		#show sentinel popup animation
		ui.play_sentinel_pop(Data.SENTINEL_DATA[chosen_enum]["name"])


	# Rebuild the animation list.
	# All sentinels are still allowed to appear while rolling.
	sentinel_roll_thumbnails = _build_sentinel_roll_thumbnails()

	var save = get_tree().get_first_node_in_group("save")
	if save:
		save.save_game()
	
func _update_sentinel_card_visual(sentinel_enum: Data.Sentinel) -> void:
	var container = $SentinelStuff/ScrollContainer/RealSentinelContainer

	for card in container.get_children():
		if card.id == sentinel_enum:
			var image: TextureRect = card.get_node("TextureRect/TextureRect")
			var locked_image: TextureRect = card.get_node("TextureRect/locked")
			var label: Label = card.get_node("TextureRect/Label")

			locked_image.visible = false
			image.modulate = Color.WHITE
			label.text = Data.SENTINEL_DATA[sentinel_enum].get("name", "")

			break
			
func _on_back_btn_pressed() -> void:
	UISound.play_close()
	if $SentinelStuff/ScrollContainer.visible == true:
		$SentinelStuff/ScrollContainer.visible = false
		$SentinelStuff/SentinelList.visible = true
		$SentinelStuff/SentinelRoll.visible = true
		$SentinelStuff/Core.visible = true
		$SentinelStuff/Databasebg.visible = false

		if Data.is_sandbox:
			$SentinelStuff/Rollbtn.visible = false
		else:
			$SentinelStuff/Rollbtn.visible = true
			_refresh_core_labels()

	elif $SentinelStuff.visible:
		$SentinelStuff.hide()
		$TextureRect/ScrollContainer.visible = true
		$SentinelStuff.visible = false
		%BigPic.visible = false

	else:
		if %SentinelsContainer.visible == true:
			get_tree().paused = false
			%BigPic.visible = false
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
		
		if $SentinelStuff/ScrollContainer.visible == true:
			$SentinelStuff/ScrollContainer.visible = false
			$SentinelStuff/Rollbtn.visible = true
			$SentinelStuff/SentinelList.visible = true
	$SentinelStuff/Databasebg.hide()

func _on_tower_btn_pressed() -> void:
	UISound.play_click()
	$TextureRect/ScrollContainer.visible = true
	$SentinelStuff.visible = false
	%BigPic.visible = true
	%BigPic.texture = null
	$SentinelStuff/Databasebg.visible = false
	

func _on_sentinel_btn_pressed() -> void:
	UISound.play_click()
	$TextureRect/Unlock.hide()
	$SentinelStuff/Core.show()
	$TextureRect/ScrollContainer.visible = false
	$TextureRect/UpgradeButton.visible = false
	%BigPic.visible = false
	$TextureRect/BigTowerName.visible = false
	$TextureRect/StatPanel.visible = false
	$TextureRect/UpgradePanel.visible = false
	$SentinelStuff.visible = true
	$SentinelStuff/SentinelRoll.visible = true
	$SentinelStuff/ScrollContainer.visible = false
	$SentinelStuff/SentinelList.visible = true
	$SentinelStuff/Databasebg.visible = false
	
	
	if Data.is_sandbox:
		$SentinelStuff/Rollbtn.visible = false
	else:
		$SentinelStuff/Rollbtn.visible = true
		_refresh_core_labels()

	if Data.is_vmmode:
		_show_sentinel_list_view()

func _on_sentinel_list_pressed() -> void:
	UISound.play_click()
	_show_sentinel_list_view()

func _show_sentinel_list_view() -> void:
	$SentinelStuff/SentinelRoll.visible = false
	$SentinelStuff/ScrollContainer.visible = true
	$SentinelStuff/Rollbtn.visible = false
	$SentinelStuff/SentinelList.visible = false
	$SentinelStuff/Core.visible = false


func _on_unlock_pressed() -> void:
	if selected_tower == null:
		return

	if Data.is_sandbox:
		return

	var tower_data: Dictionary = Data.TOWER_DATA[selected_tower]

	# ==========================================
	# CHECK IF TOWER IS ALLOWED TO BE UNLOCKED
	# ==========================================
	var is_unlockable: bool = bool(tower_data.get("unlockable", false))

	if not is_unlockable:
		UISound.play_close()
		print("Tower is not unlockable: ", tower_data.get("name", "Unknown"))
		return

	UISound.play_unlock()

	# Already unlocked
	if bool(tower_data.get("isUnlocked", false)):
		return

	# Check wave requirement
	var required_wave: int = int(tower_data.get("waveUnlocked", 0))

	if required_wave > 0 and Data.current_wave < required_wave:
		print("Cannot unlock tower.")
		print("Required Wave: ", required_wave)
		print("Current Wave: ", Data.current_wave)
		return

	# ==========================================
	# UNLOCK TOWER
	# ==========================================
	tower_data["isUnlocked"] = true

	print("Tower unlocked: ", tower_data.get("name", "Unknown"))

	# Restore BigPic
	%BigPic.modulate = Color(1, 1, 1, 1)

	# Restore tower name
	$TextureRect/BigTowerName.text = tower_data["name"]

	# Update main game UI tower card
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.unlock_tower_card(selected_tower)

	# Update corresponding tower card
	for tower_card in %SentinelsContainer.get_children():
		if tower_card.id == selected_tower:
			tower_card.update_unlock_status()
			break

	# Update upgrade UI
	$TextureRect/UpgradeButton.visible = true
	$TextureRect/Unlock.visible = false

	update_stat_label()
	update_upgrade_ui()
	update_tier_buttons()

	# Save unlock
	var save = get_tree().get_first_node_in_group("save")
	if save:
		save.save_game()
		

func _on_rollbtn_pressed() -> void:
	if sentinel_roll_active:
		return

	var locked_sentinels = _get_locked_sentinels()

	# All sentinels have already been unlocked
	if locked_sentinels.is_empty():
		UISound.play_close()
		return

	if sentinel_roll_thumbnails.is_empty():
		return

	var roll_cost: int = Data.get_sentinel_roll_cost()

	if Data.sentinel_cores < roll_cost:
		UISound.play_close()
		return

	UISound.play_click()

	Data.sentinel_cores -= roll_cost

	$SentinelStuff/SentinelRoll/Sentinel.visible = true
	sentinel_roll_active = true
	$SentinelStuff/Rollbtn.disabled = true

	await _animate_sentinel_roll(locked_sentinels)

	_refresh_core_labels()
	sentinel_roll_active = false


var sentinel_name: Array = [
	"Ethical Hacker",
	"System Administrator",
	"Intrusion Analyst",
	"Security Architect",
	"Malware Analyst",
	"Deception Specialist",
	]

	
enum Sentinel {ETHICAL, SYSAD, INTRUSION, SECURITY, MALWARE, DECEPTION}

var SENTINEL_DATA = {
	Sentinel.ETHICAL: {
		'special_ability': "Freezes all the enemies on the field for 3 seconds.",
		'cooldown': '15 seconds',
		'passive_ability': "Slows nearby enemies by 25% of their movement speed.",
		'irl_desc': "This is a cybersecurity expert who lawfully intrudes on a computer or network. They have the permission and approval to hack into a certain computing device. Lastly, they usually provide a security assessment to provide a comprehensive way to further improve a system."
	},
		Sentinel.SYSAD: {
		'special_ability': "Repair server health by 3%.",
		'cooldown': "1 minute and 30 seconds",
		'passive_ability': "Generates gold and EXP periodically for the player.",
		'irl_desc': "Their main role is to provide support, troubleshoot problems, and ensure that the computer infrastructure, such as servers and the network, is functioning."
	},
		Sentinel.INTRUSION: {
		'special_ability': "Deploys a shield with 1500 hit points around the Server that reflects damage to attackers.",
		'cooldown': "30 seconds",
		'passive_ability': "Reduce damage to the server by 5%.",
		'irl_desc': "An Intrusion Analyst is responsible for detecting, analyzing, and responding to cybersecurity threats or unauthorized access within an organization's computer networks. They monitor network traffic, investigate security incidents, and use specialized tools to identify potential breaches or vulnerabilities. Their work helps prevent data loss and protects sensitive information by quickly addressing and mitigating cyber threats. Additionally, they often collaborate with other IT and security teams to improve overall security posture and may assist in developing security policies and response plans."
	},
		Sentinel.SECURITY: {
		'special_ability': "Increases nearby towers' attack speed by 15% for 10 seconds.",
		'cooldown': "15 seconds",
		'passive_ability': "Nearby towers gain an additional 25% range. ",
		'irl_desc': "Security Architects design, develop, and implement systems that prevent the infiltration of malware and other hacker-related intrusions across the IT network, thereby helping organisations to continue their activities without encouraging costly and damaging situations."
	},
		Sentinel.MALWARE: {
		'special_ability': "Examines detected threats, reveals their weaknesses, and instead of directly attacking enemies, it improves the effectiveness of other nearby defense towers' damage by 30% for 15 seconds.",
		'cooldown': "25 seconds",
		'passive_ability': "Nearby towers gain an additional 10% crit chance.  ",
		'irl_desc': "A malware analyst examines malicious files and applications to comprehend how malware operates and how it can be prevented or countered. Their perspectives assist cybersecurity teams in identifying, examining, and protecting against cyber threats. They provide information on malicious software, revealing its function, what it aims for, and how actors utilize it. Additionally, they are also combating malicious software."
	},
		Sentinel.DECEPTION: {
		'special_ability': "Disorient enemies upon approaching the Server for 15 seconds, causing enemies near the Server to change direction.",
		'cooldown': "30 seconds",
		'passive_ability': "Reduce damage to the server by 5%.",
		'irl_desc': "The Deception Specialist handles deception technology,  which is a strategy to attract cyber criminals away from an enterprise's true assets and divert them to a decoy or trap. The decoy mimics legitimate servers, applications, and data so that the criminal is tricked into believing that they have infiltrated and gained access to the enterprise's most important assets when in reality they have not. The strategy is employed to minimize damage and protect an organization's true assets."
	},
}

@onready var sentinel_name_card = $SentinelStuff/Databasebg/Name
@onready var sentinel_special_card = $SentinelStuff/Databasebg/Special
@onready var sentinel_cooldown_card = $SentinelStuff/Databasebg/Special/Cooldown
@onready var sentinel_passive_card = $SentinelStuff/Databasebg/Special/Cooldown/Passive
@onready var sentinel_irldesc_card = $SentinelStuff/Databasebg/Special/Cooldown/Passive/RealLifeDesc/Description
@onready var animation: AnimatedSprite2D = $SentinelStuff/Databasebg/AnimatedSprite2D
@onready var real_life_desc: Label = $SentinelStuff/Databasebg/Special/Cooldown/Passive/RealLifeDesc

func change_info(id: Data.Sentinel):
	match id:
		0:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("EthicalHacker")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("EthicalHacker")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()

		1:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("SystemAdmin")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("SystemAdmin")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()
		2:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("IntrusionAnalyst")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("IntrusionAnalyst")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()
		3:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("SecurityArchitect")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("SecurityArchitect")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()
		4:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("MalwareAnalyst")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("MalwareAnalyst")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()
		5:
			if Data.SENTINEL_DATA[id]["isUnlocked"]:
				sentinel_name_card.text = sentinel_name[id]
				sentinel_special_card.text = "Ability: %s"%SENTINEL_DATA[id]["special_ability"]
				sentinel_cooldown_card.text = "Cooldown: %s"%SENTINEL_DATA[id]["cooldown"]
				sentinel_passive_card.text = "Passive: %s"%SENTINEL_DATA[id]["passive_ability"]
				sentinel_irldesc_card.text = SENTINEL_DATA[id]["irl_desc"]
				real_life_desc.text = "Real World Description"
				animation.play("DeceptionAnalyst")
				animation.modulate = Color(1, 1, 1, 1)
				$SentinelStuff/Databasebg.show()
			else:
				sentinel_name_card.text = ""
				sentinel_special_card.text = ""
				sentinel_cooldown_card.text = ""
				sentinel_passive_card.text = ""
				sentinel_irldesc_card.text = ""
				real_life_desc.text = ""
				animation.play("DeceptionAnalyst")
				animation.modulate = Color(0, 0, 0, 0)
				$SentinelStuff/Databasebg.hide()


func _update_unlock_button() -> void:
	if selected_tower == null:
		return

	var tower_data: Dictionary = Data.TOWER_DATA[selected_tower]

	# Sandbox: everything is automatically unlocked
	if Data.is_sandbox:
		$TextureRect/Unlock.visible = false
		return

	var is_unlocked: bool = bool(tower_data.get("isUnlocked", false))

	if is_unlocked:
		$TextureRect/Unlock.visible = false
		return

	# Tower is locked
	$TextureRect/Unlock.visible = true

	var required_wave: int = int(tower_data.get("waveUnlocked", 0))

	if required_wave > 0:
		$TextureRect/Unlock/Label.text = "Unlock (Wave %d)" % required_wave
	else:
		$TextureRect/Unlock/Label.text = "Unlock"
