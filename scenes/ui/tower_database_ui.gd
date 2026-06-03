extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	var parent_size = $ScrollBarContainer/Bar.size
	var scroll_size = $ScrollBarContainer/Bar/Scroll.size
	$ScrollBarContainer/Bar/Scroll.position.x = clamp(
		$ScrollBarContainer/Bar.position.x,
		8.5,
		8.5
	)
	$ScrollBarContainer/Bar/Scroll.position.y = clamp(
		$ScrollBarContainer/Bar/Scroll.position.y,
		13,
		700
	)
	
	var tower_container_size = $TowerContainer.size
	var card_container_size = $TowerContainer/CardContainer.size
	$TowerContainer/CardContainer.position.x = clamp(
		$TowerContainer/CardContainer.position.x,
		0,
		0
	)
	$TowerContainer/CardContainer.position.y = clamp(
		$TowerContainer/CardContainer.position.y,
		-580,
		11
	)

var dragging = false
func _on_texture_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position += event.relative
		$TowerContainer/CardContainer.position -=event.relative
		


func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
			


func _on_tower_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				

func _on_tower_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_9_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_10_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position +=event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_1_pressed() -> void:
	print("yey")
