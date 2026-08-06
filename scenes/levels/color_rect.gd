extends ColorRect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Data.is_sentinel_placeable:
		color = Color(0.0, 0.439, 0.227, 0.565)
	else:
		color = Color(0.65, 0.0, 0.011, 0.565)
