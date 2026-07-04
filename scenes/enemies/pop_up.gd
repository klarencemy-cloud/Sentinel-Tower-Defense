extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Animation.visible = true
			$Info.visible = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop(false)
		

func play_animation():
	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop(true)
	$Animation/AnimationPlayer.play("pop")
