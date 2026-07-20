extends Control

var is_skippable: bool = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and GameDialogueManager.clicked == 0 and is_skippable == true:
			GameDialogueManager.clicked += 1
			var ui = get_tree().get_first_node_in_group("UI")
			ui.trigger_shake()
			$AnimationPlayer.play_backwards("pop_script")
			await get_tree().create_timer(0.8667).timeout
			is_skippable = false
			$'.'.visible = false
			$'../../../Info'.visible = true
			$'../../../Info/AnimationPlayer'.play("pop_info")
			commence_load()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_skippable = true

func commence_load():
	$'../../../Info/TextureRect/Translation_Title'.self_modulate.a = 0
	$'../../../Info/TextureRect/Translation_Title/Desc'.self_modulate.a = 0

	while $'../../../Info/TextureRect/TextureProgressBar'.value < 100:
		await get_tree().create_timer(.001).timeout
		$'../../../Info/TextureRect/TextureProgressBar'.value += 0.5
		$'../../../Info/TextureRect/Translation_Title'.self_modulate.a += .01
		$'../../../Info/TextureRect/Translation_Title/Desc'.self_modulate.a += .01
