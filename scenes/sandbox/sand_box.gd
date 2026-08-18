extends Node2D

var sandbox_setting: bool # sandbox menu toggle
const CARD_TOWER := 0
const CARD_SENTINEL := 1
const CARD_ENEMY := 2
var tower_cards_showing: int = CARD_TOWER # 0 tower, 1 sentinel, 2 enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

	
func _exit_tree() -> void:
	Data.is_sandbox = false

	$Level/UI/Control/TextureRect/SandboxMenuContainer/MaxedLVL.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliMoney.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliHealth.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliSentiCap.button_pressed = false

	Data.current_level_index = Data.before_level_index
	Data.owned_towers = Data.before_owned_towers.duplicate() # restore owned towers after sandbox
	Data.server_points = Data.before_server_points # restore server points after sandbox
	Data._restore_tower_upgrades() # restore tower upgrades after sandbox
	Offense._restore_original_server_stats() # restore server upgrade stats after sandbox
	Defense._restore_original_server_stats()
	Economy._restore_original_server_stats()
#func _process(delta: float) -> void:
	#pass


func _on_sandbox_setting_pressed() -> void:
	UISound.play_click()
	if sandbox_setting:
		sandbox_setting = false
		$Level/UI/Control/TextureRect/PlayerCurrentStats.visible = true
		$Level/UI/Control/TextureRect/SandboxMenuContainer.visible = false
	else:
		sandbox_setting = true
		$Level/UI/Control/TextureRect/PlayerCurrentStats.visible = false
		$Level/UI/Control/TextureRect/SandboxMenuContainer.visible = true


func _update_tower_enemies_button_texture() -> void:
	var button = $Level/UI/Control/TextureRect/HBoxContainer/TowerEnemiesButton
	if $Level/UI/Control/TextureRect/ScrollContainer/TowerCardsContainer.visible:
		button.texture_normal = load("res://graphics/ui/tower_card_button.png")
	elif $Level/UI/Control/TextureRect/ScrollContainer/SentinelCardsContainer.visible:
		button.texture_normal = load("res://graphics/ui/sentinel_card_button.png")
	elif $Level/UI/Control/TextureRect/ScrollContainer/EnemyCardsContainer.visible:
		button.texture_normal = load("res://graphics/ui/enemy_card_button.png")

func _on_tower_enemies_button_pressed() -> void:
	UISound.play_click()
	if tower_cards_showing == CARD_TOWER:
		$Level/UI/Control/TextureRect/ScrollContainer/TowerCardsContainer.visible = false
		$Level/UI/Control/TextureRect/ScrollContainer/SentinelCardsContainer.visible = true
		$Level/UI/Control/TextureRect/ScrollContainer/EnemyCardsContainer.visible = false
		tower_cards_showing = CARD_SENTINEL
	elif tower_cards_showing == CARD_SENTINEL:
		$Level/UI/Control/TextureRect/ScrollContainer/SentinelCardsContainer.visible = false
		if Data.is_sandbox:
			$Level/UI/Control/TextureRect/ScrollContainer/EnemyCardsContainer.visible = true
			$Level/UI/Control/TextureRect/ScrollContainer/TowerCardsContainer.visible = false
			tower_cards_showing = CARD_ENEMY
		else:
			$Level/UI/Control/TextureRect/ScrollContainer/TowerCardsContainer.visible = true
			tower_cards_showing = CARD_TOWER
	else:
		$Level/UI/Control/TextureRect/ScrollContainer/EnemyCardsContainer.visible = false
		$Level/UI/Control/TextureRect/ScrollContainer/TowerCardsContainer.visible = true
		$Level/UI/Control/TextureRect/ScrollContainer/SentinelCardsContainer.visible = false
		tower_cards_showing = CARD_TOWER

	_update_tower_enemies_button_texture()
