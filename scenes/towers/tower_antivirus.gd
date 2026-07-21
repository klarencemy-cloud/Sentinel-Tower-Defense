extends Tower

func _process(_delta: float) -> void:
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI / 2


func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if enemies:
		var fire_rotation = $Turret.rotation

		# Botnet effect: make the tower fire inaccurately
		if botnet_count > 0:
			fire_rotation += deg_to_rad(randf_range(-20.0, 20.0))

		var dir = Vector2.DOWN.rotated(fire_rotation).normalized()

		var base_damage = damage
		var final_damage = Data.calculate_crit_damage(type, base_damage)
		shoot.emit(
			position + dir * 16,
			fire_rotation,
			bullet_type,
			final_damage,
			type,
			tower_id,
			enemies[0]
		)

		$ShootSound.play()
func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")


func _on_pay_button_pressed() -> void:
	if Data.money < 50:
		return

	Data.money -= 50
	remove_ransomware()
