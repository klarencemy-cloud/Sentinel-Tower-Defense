extends Tower


func _process(_delta: float) -> void:
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI/2


func _on_reload_timer_timeout() -> void:
	if enemies:
		var dir = Vector2.DOWN.rotated($Turret.rotation).normalized()

		var base_damage = damage
		var final_damage = base_damage

		var crit_chance = Data.TOWER_DATA[type]["crit rate"] / 100.0
		var crit_multiplier = Data.TOWER_DATA[type]["crit damage"] / 100.0

		var is_crit = randf() < crit_chance

		if is_crit:
			final_damage *= 1.0 + crit_multiplier

		shoot.emit(
			position + dir * 16,
			$Turret.rotation,
			bullet_type,
			int(final_damage)
		)

		$ShootSound.play()

func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")
