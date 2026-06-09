extends Node2D

var sandbox_setting : bool #sandbox menu toggle
var tower_cards_showing: bool = true #toggles between tower and enemy cards in sandbox menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

	

func _exit_tree() -> void:
	Data.is_sandbox = false
	Data.money = 200
	Data.health = 100

	$Level/UI/Control/TextureRect/SandboxMenuContainer/MaxedLVL.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliMoney.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliHealth.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliSentiCap.button_pressed = false

#func _process(delta: float) -> void:
	#pass


func _on_sandbox_setting_pressed() -> void:
	if sandbox_setting:
		sandbox_setting = false
		$Level/UI/Control/TextureRect/PlayerCurrentStats.visible = true
		$Level/UI/Control/TextureRect/SandboxMenuContainer.visible = false
	else:
		sandbox_setting = true
		$Level/UI/Control/TextureRect/PlayerCurrentStats.visible = false
		$Level/UI/Control/TextureRect/SandboxMenuContainer.visible = true


func _on_tower_enemies_button_pressed() -> void:
	if tower_cards_showing:
		$Level/UI/Control/TextureRect/TowerCardsContainer.visible = false
		$Level/UI/Control/TextureRect/EnemyCardsContainer.visible = true
		$Level/UI/Control/TextureRect/HBoxContainer/TowerEnemiesButton.texture_normal = load("res://graphics/ui/tower_card_button.png")
		tower_cards_showing = false
	else:
		$Level/UI/Control/TextureRect/TowerCardsContainer.visible = true
		$Level/UI/Control/TextureRect/EnemyCardsContainer.visible = false
		$Level/UI/Control/TextureRect/HBoxContainer/TowerEnemiesButton.texture_normal = load("res://graphics/ui/enemy_card_button.png")
		tower_cards_showing = true
