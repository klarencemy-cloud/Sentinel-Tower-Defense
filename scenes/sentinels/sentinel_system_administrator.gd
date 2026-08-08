extends Node2D

signal removed(cell_pos: Vector2i)
signal select(tower: Tower)
var cell_pos: Vector2i = Vector2i.ZERO
var tween: Tween

var placed = false
var range_indicator: Line2D
var heal_percentage: float = .03
var cooldown = Data.SENTINEL_DATA[1]["cooldown"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func _ready() -> void:
	ability_cooldown()
	create_range_indicator()
	
func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
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
	Data.sentinel_sysad_deployed = false
	Data.deactivate.emit()

func hide_ui():
	$TowerMenu.hide()
	hide_range()

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

	var radius: float = Data.SENTINEL_DATA[1].get("range", 0.0)

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
