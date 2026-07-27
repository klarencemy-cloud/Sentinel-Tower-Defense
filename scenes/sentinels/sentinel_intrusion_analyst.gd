extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)


var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false


var cooldown = Data.SENTINEL_DATA[1]["cooldown"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func _ready() -> void:
	ability_cooldown()
	damage_reduction(true)
	
func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if placed:
			select.emit(self)
			$TowerMenu.reveal()
		else:
			placed = true
		
func _on_tower_menu_delete_press() -> void:
	emit_signal("removed", cell_pos)
	queue_free()
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()
	Data.sentinel_intrusion_deployed = false
	Data.deactivate.emit()
	Data.destroy_shield.emit()
	damage_reduction(false)


func hide_ui():
	$TowerMenu.hide()


func _on_reload_timer_timeout() -> void:
	Data.deploy_shield.emit()

func damage_reduction(state: bool) -> void:
	if state:
		Data.damage_reduction = .05
	if not state:
		Data.damage_reduction = 0