extends CanvasLayer
var tower_card_scene = preload("res://scenes/ui/tower_card_for_upgrades.tscn")

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
	update_speed_label()

func update_speed_label() -> void:
	var reload_time = Data.TOWER_DATA[selected_tower]['reload_time']
	$StatPanel/StatsContainer/TextureRect/SpeedText.text = str(reload_time)
	
func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true;
	$SentinelUpgradeUi.visible = false;

func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false;
	$SentinelUpgradeUi.visible = true;
	
	

func _on_upgrade_button_pressed() -> void:

	$VScrollBar.visible = false
	%SentinelsContainer.visible = false
	%BigPic.position.x -= 297
	$BigTowerName.position.x -= 297
	$UpgradeButton.visible = false
	$StatPanel.visible = true

func _on_back_btn_pressed() -> void:
	if %SentinelsContainer.visible == false:
		%SentinelsContainer.visible = true
		$VScrollBar.visible = true
		%BigPic.position.x += 297
		$BigTowerName.position.x += 297
		$UpgradeButton.visible = true
		$StatPanel.visible = false
	else:
		get_tree().paused = false
		visible = false
