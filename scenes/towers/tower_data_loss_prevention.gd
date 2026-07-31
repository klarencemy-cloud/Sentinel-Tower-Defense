extends Tower

func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if enemies:
		var target = enemies[0]
		var dir = (target.global_position - global_position).normalized()
		var fire_rotation = Vector2.DOWN.angle_to(dir)

		# Botnet effect: make the tower fire inaccurately
		if botnet_count > 0:
			fire_rotation += deg_to_rad(randf_range(-20.0, 20.0))

		var base_damage = damage
		var final_damage = Data.calculate_crit_damage(type, base_damage)
		shoot.emit(
			position + dir * 16,
			fire_rotation,
			bullet_type,
			final_damage,
			type,
			tower_id
		)

		$ShootSound.play()

func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")

func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()