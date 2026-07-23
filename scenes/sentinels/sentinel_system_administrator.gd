extends Node2D

signal select(tower: Tower)
var tween: Tween


var heal_percentage: float = .03
var cooldown = Data.SENTINEL_DATA[0]["cooldown"]

func ability_cooldown():
	$ReloadTimer.wait_time = cooldown

func _ready() -> void:
	ability_cooldown()
	
func _process(delta: float) -> void:
	pass


# func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		var delay_timer := get_node_or_null("DelayTimer")

# 		if delay_timer == null or delay_timer.time_left <= 0.0:
# 			select.emit(self)
# 			$TowerMenu.reveal()


func _on_reload_timer_timeout() -> void:
	if tween:
		tween.kill()


	if Data.health < Data.default_health:
		var heal_amount = Data.health * heal_percentage
		Data.health += heal_amount
		$HealGain.position.y = -138.01
		$HealGain.text = "[img]res://graphics/icons/heal.png[/img] " + str(round(heal_amount))


	$GoldGain.position.y = -138.01
	var gold_amoumt: int = randi_range(50, 100)
	$GoldGain.text = "[img]res://graphics/currency/gold_gain.png[/img] " + str(gold_amoumt)
	Data.money += gold_amoumt
	tween = create_tween()

	tween.tween_property($HealGain, "position:y", -160, 1)
	tween.parallel().tween_property($HealGain, "modulate:a", 1, 1)
	tween.tween_property($HealGain, "modulate:a", 0, 1)
	
	tween.tween_property($GoldGain, "position:y", -160, 1)
	tween.parallel().tween_property($GoldGain, "modulate:a", 1, 1)
	tween.tween_property($GoldGain, "modulate:a", 0, 1)

	
	$CoinRain.emitting = true
	$Glow.emitting = true
