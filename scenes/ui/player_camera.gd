extends Camera2D

@export var acceleration: float = 1
@export var target: Node2D
@export var start_zoom: Vector2 = Vector2(1.0, 1.0)
@export var min_zoom: Vector2 = Vector2(0.7, 0.7)
@export var max_zoom: Vector2 = Vector2(2.0, 2.0)
@export var edge_scroll_threshold: float = 40.0
@export var edge_scroll_speed: float = 1200.0


const WHEEL_ZOOM_STEP = 0.15
const PINCH_ZOOM_SPEED = 0.004

var drag: bool = false
var touch_points: Dictionary = {}
var last_pinch_distance: float = 0.0
var world_min := Vector2.ZERO
var world_max := Vector2.ZERO

var _bounds_computed := false

func _ready() -> void:
	zoom = start_zoom.clamp(min_zoom, max_zoom)

	# try to auto-detect MapBoundary in the current scene and set bounds
	var root_scene = get_tree().get_current_scene()
	if root_scene == null and get_tree().get_root().get_child_count() > 0:
		root_scene = get_tree().get_root().get_child(0)
	if root_scene:
		var map_boundary = root_scene.get_node_or_null("BG/MapBoundary")
		if map_boundary == null:
			map_boundary = _recursive_find(root_scene, "MapBoundary")
		if map_boundary and map_boundary is Area2D:
			set_world_bounds(map_boundary)

func _unhandled_input(event: InputEvent) -> void:
	# When placing a tower, disable camera panning/drag so placement is stable
	if Data.is_placing_tower:
		if event is InputEventScreenDrag or event is InputEventMouseButton or event is InputEventMouseMotion:
			return

	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
		return

	if event is InputEventScreenDrag:
		_handle_screen_drag(event)
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drag = event.pressed
			# when releasing drag, ensure camera is clamped back into bounds
			if not event.pressed:
				_clamp_camera()
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(WHEEL_ZOOM_STEP)
			get_viewport().set_input_as_handled()
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-WHEEL_ZOOM_STEP)
			get_viewport().set_input_as_handled()

	if event is InputEventMouseMotion:
		if drag:
			position -= event.relative * acceleration
			_clamp_camera()


@export var max_shake: float = 30.0
@export var shake_fade: float = 30.0
var shake_strength: float = 0.0

func trigger_shake() -> void:
	shake_strength = max_shake

func shell_tremor(intensity: float):
	shake_strength = intensity

func _process(_delta: float) -> void:
	if not Data.is_placing_tower and target:
		position = target.position
		_clamp_camera()

	if Data.is_placing_tower:
		_position_edge_scroll(_delta)

	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * _delta)
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))


func _apply_zoom(amount: float) -> void:
	zoom = (zoom + Vector2.ONE * amount).clamp(min_zoom, max_zoom)
	_clamp_camera()

func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)

	last_pinch_distance = _get_pinch_distance()

func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	if not touch_points.has(event.index):
		return

	touch_points[event.index] = event.position

	if touch_points.size() == 2:
		var pinch_distance: float = _get_pinch_distance()
		if last_pinch_distance > 0.0:
			_apply_zoom((pinch_distance - last_pinch_distance) * PINCH_ZOOM_SPEED)
			get_viewport().set_input_as_handled()
		last_pinch_distance = pinch_distance

func _get_pinch_distance() -> float:
	if touch_points.size() != 2:
		return 0.0

	var points: Array = touch_points.values()
	return points[0].distance_to(points[1])

func _position_edge_scroll(_delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var scroll_dir = Vector2.ZERO

	if mouse_pos.x <= edge_scroll_threshold:
		scroll_dir.x = -1
	elif mouse_pos.x >= viewport_size.x - edge_scroll_threshold:
		scroll_dir.x = 1

	if mouse_pos.y <= edge_scroll_threshold:
		scroll_dir.y = -1
	elif mouse_pos.y >= viewport_size.y - edge_scroll_threshold:
		scroll_dir.y = 1

	if scroll_dir != Vector2.ZERO:
		position += scroll_dir.normalized() * edge_scroll_speed * _delta

	# clamp after scrolling
	_clamp_camera()

func set_world_bounds(boundary: Area2D) -> void:
	var polygon := boundary.get_node("CollisionPolygon2D") as CollisionPolygon2D
	if polygon == null:
		return

	var points := polygon.polygon

	world_min = points[0]
	world_max = points[0]

	for p in points:
		world_min.x = min(world_min.x, p.x)
		world_min.y = min(world_min.y, p.y)
		world_max.x = max(world_max.x, p.x)
		world_max.y = max(world_max.y, p.y)

	world_min += boundary.global_position
	world_max += boundary.global_position
	_bounds_computed = true
	
func _clamp_camera() -> void:
	if not _bounds_computed:
		return

	var vp_size: Vector2 = get_viewport_rect().size
	var half: Vector2 = (vp_size * 0.5) * zoom

	var min_x = world_min.x + half.x
	var max_x = world_max.x - half.x
	var min_y = world_min.y + half.y
	var max_y = world_max.y - half.y

	# if bounds smaller than viewport, center camera inside bounds
	if min_x > max_x:
		position.x = (world_min.x + world_max.x) * 0.5
	else:
		position.x = clamp(position.x, min_x, max_x)

	if min_y > max_y:
		position.y = (world_min.y + world_max.y) * 0.5
	else:
		position.y = clamp(position.y, min_y, max_y)


func _recursive_find(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	for child in node.get_children():
		if child is Node:
			var res = _recursive_find(child, name)
			if res:
				return res
	return null
