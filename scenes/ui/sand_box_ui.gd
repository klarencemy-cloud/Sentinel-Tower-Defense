extends Control


#@onready var map_selection: Control = $MapSelection
#@onready var carousel: CarouselContainer = $MapSelection/CarouselContainer

#func _process(_delta: float) -> void:
	#var selected_carousel_node = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index)
	#print(selected_carousel_node.name)
	#print(selected_carousel_node.size)
	#print(selected_carousel_node.position)
var selected_map: String

func _on_right_btn_pressed() -> void:
	$CarouselContainer._right()


func _on_left_btn_pressed() -> void:
	$CarouselContainer._left()


func _on_start_game_pressed() -> void:
	var selected_carousel_node = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index)

	selected_map = selected_carousel_node.name
	var temp_level_index = Data.current_level_index
	match selected_map:
		"Map1":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 0
		"Map2":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 1
		"Map3":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 2
		"Map4":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 3
		"Map5":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 4
		"Map6":
			Data.before_level_index = temp_level_index
			Data.current_level_index = 5


	Data.is_sandbox = true
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")
