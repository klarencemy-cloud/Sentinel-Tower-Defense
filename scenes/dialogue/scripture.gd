extends CanvasLayer
var is_skippable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Pop/Overlay/Animation/RedPop/TextureRect.rotation += .005


func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and is_skippable:
			$Pop/Info/AnimationPlayer.play_backwards("pop_info")
			await get_tree().create_timer(0.3).timeout
			is_skippable = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop2(false)
			$Pop/Animation.visible = true
			$Pop/Info.visible = false
			GameDialogueManager.clicked = 0
			await get_tree().create_timer(1).timeout
			get_tree().paused = false


func play_animation(script_name: String, index: int):
	print("yey")
	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop2(true)
	$Pop/Overlay/Animation/AnimationPlayer.play("pop_script")
	
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1