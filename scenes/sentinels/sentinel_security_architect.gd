extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)
var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false

var heal_percentage: float = .03
var cooldown = Data.SENTINEL_DATA[3]["cooldown"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func _ready() -> void:
	ability_cooldown()

	
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


func _on_reload_timer_timeout() -> void:
	if Data.health < Data.default_health:
		var heal_amount = Data.health * heal_percentage
		Data.health += heal_amount
		$HealGain.position.y = -193.01
		$HealGain.text = "[img]res://graphics/icons/heal.png[/img] " + str(round(heal_amount))

	$GoldGain.position.y = -193.01
	var gold_amoumt: int = randi_range(50, 100)
	$GoldGain.text = "[img]res://graphics/currency/gold_gain.png[/img] " + str(gold_amoumt)
	Data.money += gold_amoumt

	toggle_heal_gain()
	toggle_gold_gain()
	$CoinRain.emitting = true
	$Glow.emitting = true
	ability_cooldown()

func toggle_heal_gain():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($HealGain, "position:y", -215, 1)
	tween.parallel().tween_property($HealGain, "modulate:a", 1, 1)
	tween.tween_property($HealGain, "modulate:a", 0, 1)

	
func toggle_gold_gain():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($GoldGain, "position:y", -215, 1)
	tween.parallel().tween_property($GoldGain, "modulate:a", 1, 1)
	tween.tween_property($GoldGain, "modulate:a", 0, 1)

func _on_sentinel_skill_area_entered(area: Area2D) -> void:
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower
		var source_id = get_instance_id()
		if not tower == null:
			var shape = tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
			var range_buff = shape.radius * .20
			shape.radius = max(shape.radius + range_buff, 10)
			tower.reload_time = tower.original_reload_time - (tower.original_reload_time * .15)
			tower.get_node("ReloadTimer").wait_time = tower.reload_time
			print(tower.reload_time)

func _on_sentinel_skill_area_exited(area: Area2D) -> void:
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower
		var source_id = get_instance_id()
		if not tower == null:
				var shape = tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
				shape.radius = tower.range
