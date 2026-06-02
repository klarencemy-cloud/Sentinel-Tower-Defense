extends Control

var cost: int = 100
signal upgrade_press
signal delete_press


func _ready() -> void:
	toggle_active(Data.money)
	$UpgradeButton.text = 'Upgrade (' + str(cost) + ')'

func _on_upgrade_button_pressed() -> void:
	upgrade_press.emit()


func reveal(upgraded: bool):
	show()
	if upgraded:
		$UpgradeButton.hide()

func toggle_active(money: int):
	$UpgradeButton.disabled = cost > money


func _on_delete_button_pressed() -> void:
	delete_press.emit()


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var tap_pos = get_global_mouse_position()
		if not $UpgradeButton.get_global_rect().has_point(tap_pos) and not $DeleteButton.get_global_rect().has_point(tap_pos):
			get_parent().hide_ui()

