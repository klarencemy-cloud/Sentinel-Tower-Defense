extends Control

var st_cutscene = false
var nd_cutscene = false
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if st_cutscene == false:
		st_cutscene = true
		$'.'.visible = false
		GameDialogueManager.show_dialogue_backstory()
	elif st_cutscene and !nd_cutscene:
		nd_cutscene = true
		$'.'.visible = false
		GameDialogueManager.show_dialogue_wave2_defeat()