extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)
var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false

var heal_percentage: float = .03
var cooldown = Data.SENTINEL_DATA[3]["cooldown"]
var duration = Data.SENTINEL_DATA[3]["duration"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func skill_duration():
	$SkillDuration.wait_time = duration

func _ready() -> void:
	ability_cooldown()
	skill_duration()
	$SkillDuration.start()
	$SentinelSkill.monitoring = true
	
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
	Data.sentinel_security_deployed = false
	Data.deactivate.emit()

func hide_ui():
	$TowerMenu.hide()


func _on_sentinel_skill_area_entered(area: Area2D) -> void:
	if area.name == "ClickArea":
		apply_tower_buff(area)
		

func _on_sentinel_skill_area_exited(area: Area2D) -> void:
	if area.name == "ClickArea":
		remove_tower_buff(area)


func apply_tower_buff(area: Area2D):
	ability_cooldown()
	skill_duration()
	var tower = area.get_parent() as Tower
	if not tower == null:
		var shape = tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
		var range_buff = shape.radius * .20
		shape.radius = max(shape.radius + range_buff, 10)
		tower.reload_time = tower.original_reload_time - (tower.original_reload_time * .15)
		tower.get_node("ReloadTimer").wait_time = tower.reload_time

func remove_tower_buff(area: Area2D):
	ability_cooldown()
	skill_duration()
	var tower = area.get_parent() as Tower
	if not tower == null:
		var shape = tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
		shape.radius = tower.range
		tower.reload_time = tower.original_reload_time
		tower.get_node("ReloadTimer").wait_time = tower.reload_time


func _on_skill_duration_timeout() -> void:
	$SentinelSkill.monitoring = false
	$ReloadTimer.start()
	

func _on_reload_timer_timeout() -> void:
	$SentinelSkill.monitoring = true
	$SkillDuration.start()