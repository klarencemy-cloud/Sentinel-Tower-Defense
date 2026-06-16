extends Node


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game mode/gamemode.tscn")


#func _on_sandbox_pressed() -> void:
	#Data.is_sandbox = true
	#get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_database_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/database/database.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


var state: bool = false
func _on_settings_pressed() -> void:
	if !state:
		$ButtonManager/Exit.visible = true
		$ButtonManager/Config.visible = true
		state = true
	else:
		$ButtonManager/Exit.visible = false
		$ButtonManager/Config.visible = false
		state = false
