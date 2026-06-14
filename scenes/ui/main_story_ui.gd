extends Node

@onready var wave: Label = $Text/Wave
@onready var difficulty: Label = $Text/Difficulty
@onready var boss: TextureRect = $Image/Boss

var wave_num: int = Data.current_wave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave.text = "Wave " + str(max(1, wave_num))

	if wave_num < 20:
		difficulty.text = "EASY"
		difficulty.add_theme_color_override("font_color", Color.GREEN)

		if wave_num < 11:
			boss.texture = load("res://graphics/bosses/Virus.png")
		else:
			boss.texture = load("res://graphics/currency/gold.png")
	
	elif wave_num < 30:
		difficulty.text = "MEDIUM"
		difficulty.add_theme_color_override("font_color", Color.ORANGE)

		boss.texture = load("res://graphics/bullets/big.png")

	elif wave_num < 50:
		difficulty.text = "HARD"
		difficulty.add_theme_color_override("font_color", Color.RED)

		if wave_num < 40:
			boss.texture = load("res://graphics/bullets/bomb.png")
		else:
			boss.texture = load("res://graphics/bullets/default.png")
	
	else:
		difficulty.text = "EXTREME"
		difficulty.add_theme_color_override("font_color", Color(0.5, 0, 0))

		match wave_num:
			50:
				boss.texture = load("res://graphics/currency/experience.png")
			51:
				boss.texture = load("res://graphics/currency/sentinel_core.png")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn") # Replace with function body.
