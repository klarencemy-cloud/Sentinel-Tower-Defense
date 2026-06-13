extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var victory: Label = $CenterContainer/Victory
@onready var continue_button: Button = $ContinueButton
@onready var click: Label = $Click

var can_click := false


func _fade(target_alpha: float, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

func _fade_continue_label(target_alpha: float, duration: float = 1.5):
	var tween = create_tween()
	tween.tween_property(click, "modulate:a", target_alpha, duration)
	return tween

func _fade_victory(target_alpha: float, duration: float = 1.5):
	var tween = create_tween()
	tween.tween_property(victory, "modulate:a", target_alpha, duration)
	return tween

func _show_victory_overlay() -> void:
	visible = true

	await get_tree().create_timer(1.5).timeout
	print("Showing victory overlay")
	continue_button.visible = true
	can_click = true


func _on_continue_button_pressed() -> void:
	if not can_click:
		return
	get_tree().change_scene_to_file("res://scenes/victoryscreen/victory_screen.tscn")

