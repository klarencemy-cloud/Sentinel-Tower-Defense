extends Control


func _ready() -> void:
	pass
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$AnimationPlayer.play_backwards("pop")
			await get_tree().create_timer(0.8667).timeout
			$'.'.visible = false
			$'../Info'.visible = true
