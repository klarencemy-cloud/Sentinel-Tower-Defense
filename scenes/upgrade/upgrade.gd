extends CanvasLayer
var tower_card_scene = preload("res://scenes/ui/tower_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$SentinelsContainer.add_child(tower_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_towers_pressed() -> void:
	$TowerUpgradeUi.visible = true;
	$SentinelUpgradeUi.visible = false;

func _on_sentinel_pressed() -> void:
	$TowerUpgradeUi.visible = false;
	$SentinelUpgradeUi.visible = true;1
	
	
func _on_back_pressed() -> void:
	get_tree().paused = false
	visible = false
