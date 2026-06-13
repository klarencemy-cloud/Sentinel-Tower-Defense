extends CanvasLayer
var tower_card_scene = preload("res://scenes/ui/tower_card_for_upgrades.tscn")
var upgrade1_level = 0
var upgrade2_level = 0
var upgrade3_level = 0
var upgrade4_level = 0
var upgrade5_level = 0
var upgrade6_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$SentinelsContainer.add_child(tower_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var selected_tower: Data.Tower = Data.Tower.BASIC

func set_selected_tower(tower_enum: Data.Tower) -> void:
	selected_tower = tower_enum
	$BigTowerName.text = Data.TOWER_DATA[tower_enum]['name']
	$BigPic.texture = load(Data.TOWER_DATA[tower_enum]['thumbnail'])
	$UpgradeButton.visible = true
	update_stat_label()

func update_stat_label() -> void:
	var damage = Data.TOWER_DATA[selected_tower]['damage']
	$StatPanel/VBoxContainer/DamageContainer/DamagePic/DamageText.text = str(damage)
	var reload_time = Data.TOWER_DATA[selected_tower]['reload_time']
	$StatPanel/VBoxContainer/SpeedContainer/SpeedPic/SpeedText.text = str(reload_time)
	var range = Data.TOWER_DATA[selected_tower]['range']
	$StatPanel/VBoxContainer/RangeContainer/RangePic/RangeText.text = str(range)
	$UpgradePanel/Upgrade1/Upgrade1Label.text = Data.TOWER_DATA[selected_tower]['upgrade1']
	$UpgradePanel/Upgrade2/Upgrade2Label.text = Data.TOWER_DATA[selected_tower]['upgrade2']
	$UpgradePanel/Upgrade3/Upgrade3Label.text = Data.TOWER_DATA[selected_tower]['upgrade3']
	$UpgradePanel/Upgrade4/Upgrade4Label.text = Data.TOWER_DATA[selected_tower]['upgrade4']
	$UpgradePanel/Upgrade5/Upgrade5Label.text = Data.TOWER_DATA[selected_tower]['upgrade5']
	$UpgradePanel/Upgrade6/Upgrade6Label.text = Data.TOWER_DATA[selected_tower]['upgrade6']
	
func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true;
	$SentinelUpgradeUi.visible = false;

func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false;
	$SentinelUpgradeUi.visible = true;
	
	
func _on_upgrade_button_pressed() -> void:
	$StatPanel/CurrentStat.text = $BigTowerName.text
	$VScrollBar.visible = false
	%SentinelsContainer.visible = false
	%BigPic.position.x -= 297
	$BigTowerName.visible = false
	$UpgradeButton.visible = false
	$StatPanel.visible = true
	$UpgradePanel.visible = true

func _on_back_btn_pressed() -> void:
	if %SentinelsContainer.visible == false:
		%SentinelsContainer.visible = true
		$VScrollBar.visible = true
		%BigPic.position.x += 297
		$BigTowerName.position.x += 297
		$UpgradeButton.visible = true
		$StatPanel.visible = false
		$StatPanel.texture = load("res://graphics/container/stats.png")
		$UpgradePanel.visible = false
	else:
		get_tree().paused = false
		visible = false


func _on_stat_panel_left_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/stats.png")


func _on_stat_panel_right_pressed() -> void:
	$StatPanel.texture = load("res://graphics/container/ability.png")


func _on_tier_1_btn_pressed() -> void:
	$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierClicked.png")
	$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierUnclicked.png")
	$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierUnclicked.png")
	$UpgradePanel/Upgrade1.visible = true
	$UpgradePanel/Upgrade2.visible = true
	$UpgradePanel/Upgrade3.visible = false
	$UpgradePanel/Upgrade4.visible = false
	$UpgradePanel/Upgrade5.visible = false
	$UpgradePanel/Upgrade6.visible = false
	
func _on_tier_2_btn_pressed() -> void:
	if upgrade1_level == 3 and upgrade2_level == 3:
		$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierUnclicked.png")
		$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierClicked.png")
		$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierUnclicked.png")
		$UpgradePanel/Upgrade1.visible = false
		$UpgradePanel/Upgrade2.visible = false
		$UpgradePanel/Upgrade3.visible = true
		$UpgradePanel/Upgrade4.visible = true
		$UpgradePanel/Upgrade5.visible = false
		$UpgradePanel/Upgrade6.visible = false
	
	
func _on_tier_3_btn_pressed() -> void:
	if upgrade1_level == 6 and upgrade2_level == 6:
		$UpgradePanel/Tier1Btn.texture_normal = load("res://graphics/buttons/1stTierUnclicked.png")
		$UpgradePanel/Tier2Btn.texture_normal = load("res://graphics/buttons/2ndTierUnclicked.png")
		$UpgradePanel/Tier3Btn.texture_normal = load("res://graphics/buttons/3rdTierClicked.png")
		$UpgradePanel/Upgrade1.visible = false
		$UpgradePanel/Upgrade2.visible = false
		$UpgradePanel/Upgrade3.visible = false
		$UpgradePanel/Upgrade4.visible = false
		$UpgradePanel/Upgrade5.visible = true
		$UpgradePanel/Upgrade6.visible = true


func _on_upgrade_1_pressed() -> void:
	if upgrade1_level < 3:
		upgrade1_level += 1
		
	if upgrade1_level >= 1:
		$UpgradePanel/Upgrade1/Upgrade1a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade1_level >= 2:
		$UpgradePanel/Upgrade1/Upgrade1b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade1_level >= 3:
		$UpgradePanel/Upgrade1/Upgrade1c.texture = load("res://graphics/upgrade/Upgraded.png")


func _on_upgrade_2_pressed() -> void:
	if upgrade2_level < 3:
		upgrade2_level += 1
		
	if upgrade2_level >= 1:
		$UpgradePanel/Upgrade2/Upgrade2a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade2_level >= 2:
		$UpgradePanel/Upgrade2/Upgrade2b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade2_level >= 3:
		$UpgradePanel/Upgrade2/Upgrade2c.texture = load("res://graphics/upgrade/Upgraded.png")




func _on_upgrade_3_pressed() -> void:
	if upgrade3_level < 3:
		upgrade3_level += 1
		
	if upgrade3_level >= 1:
		$UpgradePanel/Upgrade3/Upgrade3a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade3_level >= 2:
		$UpgradePanel/Upgrade3/Upgrade3b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade3_level >= 3:
		$UpgradePanel/Upgrade3/Upgrade3c.texture = load("res://graphics/upgrade/Upgraded.png")



func _on_upgrade_4_pressed() -> void:
	if upgrade4_level < 3:
		upgrade4_level += 1
		
	if upgrade4_level >= 1:
		$UpgradePanel/Upgrade4/Upgrade4a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade4_level >= 2:
		$UpgradePanel/Upgrade4/Upgrade4b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade4_level >= 3:
		$UpgradePanel/Upgrade4/Upgrade4c.texture = load("res://graphics/upgrade/Upgraded.png")




func _on_upgrade_5_pressed() -> void:
	if upgrade5_level < 3:
		upgrade5_level += 1
		
	if upgrade5_level >= 1:
		$UpgradePanel/Upgrade5/Upgrade5a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade5_level >= 2:
		$UpgradePanel/Upgrade5/Upgrade5b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade5_level >= 3:
		$UpgradePanel/Upgrade5/Upgrade5c.texture = load("res://graphics/upgrade/Upgraded.png")


func _on_upgrade_6_pressed() -> void:
	if upgrade6_level < 3:
		upgrade6_level += 1
		
	if upgrade6_level >= 1:
		$UpgradePanel/Upgrade6/Upgrade6a.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade6_level >= 2:
		$UpgradePanel/Upgrade6/Upgrade6b.texture = load("res://graphics/upgrade/Upgraded.png")
	if upgrade6_level >= 3:
		$UpgradePanel/Upgrade6/Upgrade6c.texture = load("res://graphics/upgrade/Upgraded.png")
