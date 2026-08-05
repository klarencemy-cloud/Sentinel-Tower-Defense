extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _on_area_exited(area: Area2D) -> void:
	if area.get_overlapping_areas().is_empty():
		Data.is_tower_placeable = true

		
func _on_area_entered(area: Area2D) -> void:
	Data.is_tower_placeable = false
