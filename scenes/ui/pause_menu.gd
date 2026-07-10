extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false # makes sure it disappears at startup, just like my money

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # void of emptiness and nothingness just like my wallet

func _on_resume_pressed() -> void:
	get_tree().paused = false # unfreezes game, pag kase cinlick pause button ipapause nya game
	visible = false # go poof

func _on_quit_pressed() -> void:
	get_tree().paused = false # unfreezes game #2
	Data.wave_started = false
	visible = false # go poof #2
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn") # goes back to main menu
