extends Node

@onready var wave: Label = $Text/Wave
@onready var difficulty: Label = $Text/Difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave.text = ("Wave " + str(Data.current_wave))

	if Data.current_wave > 0 and Data.current_wave < 20:
		difficulty.text = ("Easy")
		difficulty.add_theme_color_override("font_color", Color.GREEN)
	elif Data.current_wave > 19 and Data.current_wave < 30:
		difficulty.text = ("MEDIUM")
		difficulty.add_theme_color_override("font_color", Color.ORANGE)
	elif Data.current_wave > 29 and Data.current_wave < 50:
		difficulty.text = ("HARD")
		difficulty.add_theme_color_override("font_color", Color.RED)
	else:
		difficulty.text = ("EXTREME")
		difficulty.add_theme_color_override("font_color", Color(0.5, 0, 0))


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn") # Replace with function body.
