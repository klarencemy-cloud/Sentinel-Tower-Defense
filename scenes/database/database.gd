extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")


func _on_threats_pressed() -> void:
	$TowerDatabaseUi.visible = false
	$ThreatDatabaseUi.visible = true
	$SentinelDatabaseUi.visible= false

	$ButtonManager/Towers.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/Threats.texture_normal = preload("res://graphics/buttons/active_parallelogram.png")
	$ButtonManager/Sentinels.texture_normal = preload("res://graphics/buttons/trapezoid_right.png")

func _on_towers_pressed() -> void:
	$TowerDatabaseUi.visible = true
	$ThreatDatabaseUi.visible = false
	$SentinelDatabaseUi.visible= false

	$ButtonManager/Towers.texture_normal = preload("res://graphics/buttons/active_parallelogram.png")
	$ButtonManager/Threats.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/Sentinels.texture_normal = preload("res://graphics/buttons/trapezoid_right.png")

func _on_sentinels_pressed() -> void:
	$TowerDatabaseUi.visible = false
	$ThreatDatabaseUi.visible = false
	$SentinelDatabaseUi.visible= true

	$ButtonManager/Towers.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/Threats.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/Sentinels.texture_normal = preload("res://graphics/buttons/active_trapezoid_right.png")
