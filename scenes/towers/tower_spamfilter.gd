extends Tower

func _process(_delta: float) -> void:
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI / 2

func _on_reload_timer_timeout() -> void:
	if disabled_by_ad:
		return
	if enemies.size() > 0:
		var dir = Vector2.DOWN.rotated($Turret.rotation).normalized()

		var base_damage = Data.TOWER_DATA[type]["damage"]
		var final_damage = Data.calculate_crit_damage(type, base_damage)

		shoot.emit(
			position + dir * 16,
			$Turret.rotation,
			bullet_type,
			final_damage,
			type,
			tower_id
		)

		$ShootSound.play()
