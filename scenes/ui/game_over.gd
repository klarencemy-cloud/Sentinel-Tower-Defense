extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	%txtScore.text = "You reached wave " + str(Data.current_wave) + "!"
	%btnCheckpoint.visible = Data.current_wave > 5

func _on_btn_checkpoint_pressed() -> void:
	get_tree().paused = false
	visible = false
	Data.health = 100
	Data.current_wave = max(Data.checkpoint_wave - 1, 0)
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
	

func _on_btn_quit_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")

func _on_btn_retry_pressed() -> void:
	get_tree().paused = false
	Data.current_wave = 0
	Data.checkpoint_wave = 0
	Data.health = 100
	Data.money = 200
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
