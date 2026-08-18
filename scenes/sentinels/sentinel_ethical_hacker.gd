extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)


var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false
var range_indicator: Line2D

var cooldown = Data.SENTINEL_DATA[0]["cooldown"]
var duration = Data.SENTINEL_DATA[0]["duration"]
var range = Data.SENTINEL_DATA[0]['range']

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func skill_duration():
	$SkillDuration.wait_time = duration

func _ready() -> void:
	$SentinelSkill/CollisionShape2D.shape.radius = float(range)
	ability_cooldown()
	skill_duration()
	$ReloadTimer.start()
	create_range_indicator()


func _process(delta: float) -> void:
	$AnimatedSprite2D/Cooldown.text = str(int($ReloadTimer.time_left))
	
func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	UISound.play_click()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if placed:
			select.emit(self)
			$TowerMenu.reveal()
			show_range()
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
	hide_range()

func _on_reload_timer_timeout() -> void:
	toggle_skill_icon()
	$GPUParticles2D.restart()
	$GPUParticles2D.emitting = true
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies:
		for enemy in enemies:
			enemy.ethical_hacker_freeze = true
	$SkillDuration.start()
	$AnimatedSprite2D/Cooldown.hide()

func _on_skill_duration_timeout() -> void:
	$ReloadTimer.start()
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies:
		for enemy in enemies:
			enemy.ethical_hacker_freeze = false
	$AnimatedSprite2D/Cooldown.show()

func _on_sentinel_skill_area_exited(area: Area2D) -> void:
	if area.name == "Enemy":
		area.ethical_hacker_slow = false
		

func _on_sentinel_skill_area_entered(area: Area2D) -> void:
	if area.name == "Enemy":
		area.ethical_hacker_slow = true
		
func create_range_indicator() -> void:
	if range_indicator:
		return

	range_indicator = Line2D.new()
	range_indicator.width = 2
	range_indicator.default_color = Color(1, 1, 1, 1)
	range_indicator.visible = false
	range_indicator.z_index = 100
	add_child(range_indicator)

	_update_range_indicator()

func _update_range_indicator() -> void:
	if not range_indicator:
		return

	var radius: float = Data.SENTINEL_DATA[0].get("range", 0.0)

	var points := PackedVector2Array()
	var segments := 100

	for i in range(segments + 1):
		points.append(
			Vector2(
				cos(TAU * i / segments),
				sin(TAU * i / segments)
			) * radius
		)

	range_indicator.points = points

func show_range() -> void:
	create_range_indicator()
	_update_range_indicator()
	range_indicator.visible = true

func hide_range() -> void:
	if range_indicator:
		range_indicator.visible = false


func toggle_skill_icon():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D/SkillIcon, "position:y", -215, 1)
	tween.parallel().tween_property($AnimatedSprite2D/SkillIcon, "modulate:a", 1, 1)
	tween.tween_property($AnimatedSprite2D/SkillIcon, "modulate:a", 0, 1)
	tween.tween_property($AnimatedSprite2D/SkillIcon, "position:y", -193.812, 0)
