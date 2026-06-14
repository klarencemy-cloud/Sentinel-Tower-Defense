extends Control

signal delete_press


func _ready() -> void:
	hide()


func reveal():
	show()


func _on_delete_button_pressed() -> void:
	delete_press.emit()


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var tap_pos = get_global_mouse_position()
		
		if not $DeleteButton.get_global_rect().has_point(tap_pos):
			get_parent().hide_ui()
