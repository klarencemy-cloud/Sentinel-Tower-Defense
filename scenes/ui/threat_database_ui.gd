extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
	var threat_container_size = $ThreatContainer.size
	var card_container_size = $ThreatContainer/CardContainer.size
	$ThreatContainer/CardContainer.position.x = clamp(
		$ThreatContainer/CardContainer.position.x,
		0,
		0
	)
	$ThreatContainer/CardContainer.position.y = clamp(
		$ThreatContainer/CardContainer.position.y,
		-580,
		11
	)
	
var dragging = false






func _on_scroll_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position += event.relative
		$ThreatContainer/CardContainer.position -=event.relative


func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				



func _on_threat_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			print("yey")
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_9_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_10_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$ThreatContainer/CardContainer.position +=event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
