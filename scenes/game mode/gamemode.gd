extends Node

var main_ui = preload("res://scenes/ui/main_story_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_pressed() -> void:
	UISound.play_close()
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")
	Data.is_vmmode = false

func _on_main_story_pressed() -> void:
	UISound.play_click()
	$MainStoryUI.visible = true;
	$VirtualMachineUI.visible = false;
	$SandBoxUI.visible = false
	Data.is_vmmode = false
	
	$ButtonManager/MainStory.texture_normal = preload("res://graphics/buttons/active_parallelogram.png")
	$ButtonManager/VmMode.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/SandBoxMode.texture_normal = preload("res://graphics/buttons/parallelogram.png")

func _on_vm_mode_pressed() -> void:
	UISound.play_click()
	$MainStoryUI.visible = false;
	$VirtualMachineUI.visible = true;
	$SandBoxUI.visible = false
	Data.is_vmmode = true
	$ButtonManager/MainStory.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/VmMode.texture_normal = preload("res://graphics/buttons/active_parallelogram.png")
	$ButtonManager/SandBoxMode.texture_normal = preload("res://graphics/buttons/parallelogram.png")

func _on_sand_box_mode_pressed() -> void:
	UISound.play_click()
	$MainStoryUI.visible = false;
	$VirtualMachineUI.visible = false;
	$SandBoxUI.visible = true
	Data.is_vmmode = false
	$ButtonManager/MainStory.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/VmMode.texture_normal = preload("res://graphics/buttons/parallelogram.png")
	$ButtonManager/SandBoxMode.texture_normal = preload("res://graphics/buttons/active_parallelogram.png")
