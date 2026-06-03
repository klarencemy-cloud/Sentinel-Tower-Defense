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
	
	var threat_container_size = $SentinelContainer.size
	var card_container_size = $SentinelContainer/CardContainer.size
	$SentinelContainer/CardContainer.position.x = clamp(
		$SentinelContainer/CardContainer.position.x,
		0,
		0
	)
	$SentinelContainer/CardContainer.position.y = clamp(
		$SentinelContainer/CardContainer.position.y,
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
		$SentinelContainer/CardContainer.position -=event.relative
		



func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_sentinel_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_9_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_sentinel_10_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			dragging = event.pressed  
			if event.pressed == false:
				for child in $SentinelContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$SentinelContainer/CardContainer.position +=event.relative
		for child in $SentinelContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
