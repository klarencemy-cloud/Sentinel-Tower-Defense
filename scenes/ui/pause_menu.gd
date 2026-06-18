extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	visible = false
	Data.reset_game()
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")
	
	
