extends Node

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MapDetails/Description.set_v_grow_direction(Control.GROW_DIRECTION_END)
	$CarouselContainer.toggle_tween.connect(_toggle_tween)

	for map_number in range(1, 10):
		if not Data.VM_MAP_DATA[map_number].get('unlocked', false):
			var hotspot: TextureButton = get_node("MapContainer/Map/Challenge%d" % map_number)
			hotspot.self_modulate = Color(0.35, 0.35, 0.35)


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
	UISound.play_click()
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
	UISound.play_carousel()
	$CarouselContainer._left()


func _on_start_game_pressed() -> void:
	UISound.play_click()
	var selected_carousel_node = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index)

	var map_number := int(selected_carousel_node.name.trim_prefix("Map"))
	if not Data.VM_MAP_DATA.has(map_number):
		return
	if not Data.VM_MAP_DATA[map_number].get('unlocked', false):
		return
	Data.before_level_index = Data.current_level_index
	Data.before_current_wave = Data.current_wave
	Data.before_total_money = Data.money
	Data.before_total_health = Data.health
	Data.before_max_health = Data.max_health
	Data.before_max_server_load = Data.maxserverload
	Data.before_current_server_load = Data.currentserverload
	Data.before_server_points = Data.server_points
	Data.server_points = Data.default_server_points
	Data.currentserverload = 0 #

	EnemyStats.backup()
	EnemyTower.backup()

	Data._initialize_base_tower_stats()
	Data._backup_tower_upgrades()
	Data._reset_tower_upgrades_to_base()
	Data._apply_vmmode_fixed_tower_upgrades(map_number)

	Offense._sandbox_mode()
	Defense._sandbox_mode()
	Economy._sandbox_mode()
	Data.max_health = Data.default_health
	Data.maxserverload = Data.default_system_load
	Offense._apply_vmmode_fixed_levels(map_number)
	Defense._apply_vmmode_fixed_levels(map_number)
	Economy._apply_vmmode_fixed_levels(map_number)
	Data.saved_tower_placements.clear()
	Data.saved_sentinel_placements.clear()
	Data.saved_ability_placements.clear()

	Data.before_free_towers = Data.free_towers.duplicate()
	Data.free_towers.clear()

	Data.vmmode_map_number = map_number
	Data.vmmode_resume_progress = {}

	if VMSave.has_save(map_number):
		Data.vmmode_resume_progress = VMSave.load_into_data(map_number)

	Data.current_level_index = Data.VM_MAP_DATA[map_number]['terrain_level_index']
	Data.current_wave = 1
	Data.is_vmmode = true
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_right_btn_pressed() -> void:
	UISound.play_carousel()
	$CarouselContainer._right()


func _on_challenge_9_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(8)
	_toggle_tween(9)

func _on_challenge_8_pressed() -> void:
	UISound.play_click()
	print("8")
	Data.change_challenge.emit(7)
	_toggle_tween(8)
func _on_challenge_7_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(6)
	_toggle_tween(7)
func _on_challenge_6_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(5)
	_toggle_tween(6)
func _on_challenge_5_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(4)
	_toggle_tween(5)
func _on_challenge_4_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(3)
	_toggle_tween(4)
func _on_challenge_3_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(2)
	_toggle_tween(3)
func _on_challenge_2_pressed() -> void:
	UISound.play_click()
	Data.change_challenge.emit(1)
	_toggle_tween(2)
func _on_challenge_1_pressed() -> void:
	UISound.play_click()
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
		if prev != container and prev != null:
			tween.tween_property(prev, "scale", Vector2(1, 1), 0.1)
		prev = container
	elif is_tween:
		tween.tween_property(container, "scale", Vector2(1, 1), 0.1)
		is_tween = false
		if prev != container and prev != null:
			tween.tween_property(prev, "scale", Vector2(1, 1), 0.1)
