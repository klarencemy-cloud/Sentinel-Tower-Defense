extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)


var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false


var cooldown = Data.SENTINEL_DATA[0]["cooldown"]
var duration = Data.SENTINEL_DATA[0]["duration"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func skill_duration():
	$SkillDuration.wait_time = duration

func _ready() -> void:
	ability_cooldown()
	skill_duration()
	$ReloadTimer.start()
	
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
	Data.sentinel_ethical_deployed = false
	Data.deactivate.emit()


func hide_ui():
	$TowerMenu.hide()


func _on_reload_timer_timeout() -> void:
	print("skill casted")
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies:
		for enemy in enemies:
			enemy.ethical_hacker_freeze = true
	$SkillDuration.start()

func _on_skill_duration_timeout() -> void:
	print("skill ended")
	$ReloadTimer.start()
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies:
		for enemy in enemies:
			enemy.ethical_hacker_freeze = false

func _on_sentinel_skill_area_exited(area: Area2D) -> void:
	if area.name == "Enemy":
		area.ethical_hacker_slow = false
		

func _on_sentinel_skill_area_entered(area: Area2D) -> void:
	if area.name == "Enemy":
		area.ethical_hacker_slow = true
