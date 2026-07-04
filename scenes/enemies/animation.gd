extends Control


func _ready() -> void:
	pass
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and GameDialogueManager.clicked == 0:
			GameDialogueManager.clicked += 1
			var ui = get_tree().get_first_node_in_group("UI")
			ui.trigger_shake()
			$AnimationPlayer.play_backwards("pop")
			$GPUParticles2D.emitting = false
			await get_tree().create_timer(0.8667).timeout
			$'.'.visible = false
			$'../Info'.visible = true
			$'../Info/AnimationPlayer'.play("info_pop")
