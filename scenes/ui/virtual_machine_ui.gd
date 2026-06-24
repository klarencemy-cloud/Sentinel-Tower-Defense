extends Node

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MapDetails/Description.set_v_grow_direction(Control.GROW_DIRECTION_END)
	$CarouselContainer.toggle_tween.connect(_toggle_tween)


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
		$MapContainer.visible = true
		$ButtonManager/MapBtn/ToggleLabel.text = "ZOOM"
		$CarouselContainer.visible = false
		toggleMap = true
		$ButtonManager/RightBtn.visible = false
		$ButtonManager/LeftBtn.visible = false
	elif toggleMap:
		$MapContainer.visible = false
		$ButtonManager/MapBtn/ToggleLabel.text = "MAP"
		$CarouselContainer.visible = true
		toggleMap = false
		$ButtonManager/RightBtn.visible = true
		$ButtonManager/LeftBtn.visible = true
		

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


func _on_left_btn_pressed() -> void:
	$CarouselContainer._left()


func _on_right_btn_pressed() -> void:
	$CarouselContainer._right()


func _on_challenge_9_pressed() -> void:
	Data.change_challenge.emit(8)
	_toggle_tween(9)

func _on_challenge_8_pressed() -> void:
	Data.change_challenge.emit(7)
	_toggle_tween(8)
func _on_challenge_7_pressed() -> void:
	Data.change_challenge.emit(6)
	_toggle_tween(7)
func _on_challenge_6_pressed() -> void:
	Data.change_challenge.emit(5)
	_toggle_tween(6)
func _on_challenge_5_pressed() -> void:
	Data.change_challenge.emit(4)
	_toggle_tween(5)
func _on_challenge_4_pressed() -> void:
	Data.change_challenge.emit(3)
	_toggle_tween(4)
func _on_challenge_3_pressed() -> void:
	Data.change_challenge.emit(2)
	_toggle_tween(3)
func _on_challenge_2_pressed() -> void:
	Data.change_challenge.emit(1)
	_toggle_tween(2)
func _on_challenge_1_pressed() -> void:
	Data.change_challenge.emit(0)
	_toggle_tween(1)


var is_tween: bool = false
var prev: TextureButton
func _toggle_tween(tween_num: int) -> void:
	var container = get_node("MapContainer/Map/Challenge%d"%tween_num)
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	if !is_tween or container != prev:
		tween.tween_property(container, "scale", Vector2(1.3, 1.3), 0.1)
		is_tween = true
		if prev != container:
			tween.tween_property(prev, "scale", Vector2(1, 1), 0.1)
		prev = container
	elif is_tween:
		tween.tween_property(container, "scale", Vector2(1, 1), 0.1)
		is_tween = false
		if prev != container:
			tween.tween_property(prev, "scale", Vector2(1, 1), 0.1)
