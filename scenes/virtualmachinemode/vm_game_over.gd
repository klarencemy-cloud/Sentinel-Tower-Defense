extends CanvasLayer

signal retry_pressed
signal quit_pressed


func _ready() -> void:
	visible = false


func show_result(won: bool, result_text: String) -> void:
	%txtScore.text = "SERVER SECURED!" if won else "SERVER LOST!"
	%txtKills.text = result_text
	visible = true


func _on_btn_retry_pressed() -> void:
	UISound.play_click()
	retry_pressed.emit()


func _on_btn_quit_pressed() -> void:
	UISound.play_close()
	quit_pressed.emit()
