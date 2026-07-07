extends Node

@onready var wave: Label = $Text/Wave
@onready var difficulty: Label = $Text/Difficulty
@onready var boss: TextureRect = $Image/Boss

var wave_num: int = Data.current_wave
var small_sprite: Vector2 = Vector2(3.138, 3.138)
var big_sprite: Vector2 = Vector2(1.926, 1.926)
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	# match wave_num:
	# 	0, 1, 2, 3:
	# 		difficulty.text = "EASY"
	# 		difficulty.add_theme_color_override("font_color", Color(0.129, 0.596, 0.678))
	# 		$Image/AnimatedSprite2D.play("spam")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	4, 5, 6, 7:
	# 		$Image/AnimatedSprite2D.play("virus")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	8, 9:
	# 		$Image/AnimatedSprite2D.play("adware")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	10, 11:
	# 		$Image/AnimatedSprite2D.play("ilu")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	# 	12, 13, 14, 15:
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	16, 17, 18:
	# 		$Image/AnimatedSprite2D.play("spyware")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	19:
	# 		$Image/AnimatedSprite2D.play("botnet")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	20, 21:
	# 		$Image/AnimatedSprite2D.play("conficker")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	# 	22, 23:
	# 		$Image/AnimatedSprite2D.play("creds")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	24, 25, 26, 27:
	# 		$Image/AnimatedSprite2D.play("trojan")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	28, 29:
	# 		$Image/AnimatedSprite2D.play("insider")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	30, 31:
	# 		difficulty.add_theme_color_override("font_color", Color(0.277, 0.622, 0.287))
	# 		difficulty.text = "MEDIUM"
	# 		$Image/AnimatedSprite2D.play("wannacry")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	# 	32, 33:
	# 		$Image/AnimatedSprite2D.play("rootkit")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	34, 35:
	# 		$Image/AnimatedSprite2D.play("sql")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	36, 37:
	# 		$Image/AnimatedSprite2D.play("ddos")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	38, 39:
	# 		$Image/AnimatedSprite2D.play("ransomware")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	40, 41, 42:
	# 		$Image/AnimatedSprite2D.play("nopetya")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	# 	43, 44, 45, 46, 47, 48, 49:
	# 		$Image/AnimatedSprite2D.play("zero")
	# 		$Image/AnimatedSprite2D.scale = small_sprite
	# 	50:
	# 		difficulty.add_theme_color_override("font_color", Color(0.784, 0.431, 0.118))
	# 		difficulty.text = "HARD"
	# 		$Image/AnimatedSprite2D.play("doom")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	# 	51:
	# 		difficulty.add_theme_color_override("font_color", Color(1.0, 0.0, 0.016))
	# 		difficulty.text = "EXTREME"
	# 		$Image/AnimatedSprite2D.play("trojan_horse")
	# 		$Image/AnimatedSprite2D.scale = big_sprite
	if wave_num <= 10:
		difficulty.text = "EASY"
		boss.texture = load("res://graphics/map/map1.png")
		difficulty.add_theme_color_override("font_color", Color(0.129, 0.596, 0.678))

	elif wave_num <= 20 and wave_num > 11:
		boss.texture = load("res://graphics/map/map2.png")

	elif wave_num <= 30 and wave_num > 21:
		boss.texture = load("res://graphics/map/map3.png")
	
	elif wave_num <= 40 and wave_num > 31:
		difficulty.text = "MEDIUM"
		boss.texture = load("res://graphics/map/map4.png")
		difficulty.add_theme_color_override("font_color", Color(0.277, 0.622, 0.287))

	elif wave_num <= 50 and wave_num > 41:
		difficulty.text = "HARD"
		difficulty.add_theme_color_override("font_color", Color(0.784, 0.431, 0.118))
		boss.texture = load("res://graphics/map/map5.png")
	else:
		difficulty.text = "EXTREME"
		difficulty.add_theme_color_override("font_color", Color(1.0, 0.0, 0.016))
		boss.texture = load("res://graphics/map/map5.png")


func _ready() -> void:
		wave.text = "Wave " + str(max(1, wave_num))
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn") # Replace with function body.
