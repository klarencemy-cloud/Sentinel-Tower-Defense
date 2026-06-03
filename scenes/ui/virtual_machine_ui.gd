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
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
			


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
		


func _on_final_pressed() -> void:
	pass


func _on_final_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_final_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $MapContainer/Map.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
			
	elif event is InputEventMouseMotion and dragging:
		$MapContainer/Map.position += event.relative
		for child in $MapContainer/Map.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
