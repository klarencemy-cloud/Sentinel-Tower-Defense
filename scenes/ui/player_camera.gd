extends Camera2D

@export var acceleration: float = 1
@export var target: Node2D
@export var start_zoom: Vector2 = Vector2(1.0, 1.0)
@export var min_zoom: Vector2 = Vector2(0.7, 0.7)
@export var max_zoom: Vector2 = Vector2(2.0, 2.0)


const WHEEL_ZOOM_STEP = 0.15
const PINCH_ZOOM_SPEED = 0.004

var drag: bool = false
var touch_points: Dictionary = {}
var last_pinch_distance: float = 0.0

func _ready() -> void:
	zoom = start_zoom.clamp(min_zoom, max_zoom)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
		return

	if event is InputEventScreenDrag:
		_handle_screen_drag(event)
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drag = event.pressed
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(WHEEL_ZOOM_STEP)
			get_viewport().set_input_as_handled()
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-WHEEL_ZOOM_STEP)
			get_viewport().set_input_as_handled()

	if event is InputEventMouseMotion:
		if drag:
			position -= event.relative * acceleration


@export var max_shake: float = 30.0
@export var shake_fade: float = 30.0
var shake_strength: float = 0.0

func trigger_shake() -> void:
	shake_strength = max_shake

func _process(_delta: float) -> void:
	if target:
		position = target.position

	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * _delta)
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))


func _apply_zoom(amount: float) -> void:
	zoom = (zoom + Vector2.ONE * amount).clamp(min_zoom, max_zoom)

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
