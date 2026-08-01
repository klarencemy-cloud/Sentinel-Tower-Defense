extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Data.is_tower_placeable:
		color = Color(0.0, 0.439, 0.227, 0.565)
	else:
		color = Color(0.65, 0.0, 0.011, 0.565)
