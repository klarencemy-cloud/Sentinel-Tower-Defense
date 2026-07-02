extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	visibility_changed.connect(_on_visibility_changed)
	update_display()

func update_display() -> void:
	%txtScore.text = "You reached wave " + str(Data.current_wave) + "!"
	%btnCheckpoint.visible = Data.checkpoint_wave > 0

func _on_visibility_changed() -> void:
	if visible:
		update_display()

func _on_btn_checkpoint_pressed() -> void:
	if Data.checkpoint_wave <= 0:
		return

	get_tree().paused = false
	visible = false
	Data.health = 100
	Data.current_wave = max(Data.checkpoint_wave - 1, 0)
	get_tree().change_scene_to_file("uid://h7qi8y7uyyai") # Loading screen
	

func _on_btn_quit_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")
	Data.reset_game()
	

func _on_btn_retry_pressed() -> void:
	get_tree().paused = false
	_reset_game_stats()
	Offense._reset_multipliers() # reset multipliers
	Offense._reset_levels()		 # reset levels tiers yung images
	Defense._reset_multipliers()
	Defense._reset_levels()
	Economy._reset_multipliers()
	Economy._reset_levels()
	get_tree().call_group("retry_game", "_reset_map_level")
	

func _reset_game_stats() -> void:
	Data.current_wave = 0
	Data.checkpoint_wave = 0
	Data.health = 100
	Data.money = 200
	Data.currentserverload= 0
	Data.player_level = 1
	Data.server_points = 0
	Data.experience = 0
	Data.owned_towers.clear()