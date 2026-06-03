extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent_size = $MapContainer.size
	var map_size = $MapContainer/Map.size
	$MapContainer/Map.position.x = clamp(
		$MapContainer/Map.position.x,
		parent_size.x - map_size.x,
		50
	)
	$MapContainer/Map.position.y = clamp(
		$MapContainer/Map.position.y,
		(parent_size.y - map_size.y) - 50,
		0 
	)
	
var dragging = false

func _on_map_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			

	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative


var toggleMap = false;
func _on_map_btn_pressed() -> void:
	if !toggleMap:
		$Image/SelectedMap.visible = false
		$MapContainer.visible = true
		$ButtonManager/MapBtn/ToggleLabel.text = "ZOOM"
		toggleMap = true
	elif toggleMap:
		$Image/SelectedMap.visible = true
		$MapContainer.visible = false
		$ButtonManager/MapBtn/ToggleLabel.text = "MAP"
		toggleMap = false
		
