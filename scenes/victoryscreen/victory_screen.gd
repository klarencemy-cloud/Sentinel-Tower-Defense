extends Control

func _ready() -> void:
	$Label2.text = "You've completed level %s!" % Data.current_level_index

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")
