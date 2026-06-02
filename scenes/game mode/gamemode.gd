extends Node2D

var main_ui = preload("res://scenes/ui/main_story_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")


func _on_main_story_pressed() -> void:
	$MainStoryUI.visible = true;
	$VirtualMachineUI.visible = false;


func _on_vm_mode_pressed() -> void:
	$MainStoryUI.visible = false;
	$VirtualMachineUI.visible = true;
