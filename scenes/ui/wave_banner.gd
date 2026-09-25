extends CanvasLayer

@onready var label: Label = $Label

var _queue: Array[String] = []
var _showing: bool = false

func show_message(text: String) -> void:
	_queue.append(text)
	if not _showing:
		_show_next()

func _show_next() -> void:
	if _queue.is_empty():
		_showing = false
		return
	_showing = true

	label.text = _queue.pop_front()
	label.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	tween.tween_interval(1.2)
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	tween.finished.connect(_show_next)
