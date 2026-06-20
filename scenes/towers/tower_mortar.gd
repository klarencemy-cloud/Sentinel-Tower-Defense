extends Tower


func show_crosshair():
	$CrosshairSprite.show()

func crosshair_pos_update(pos: Vector2i):
	$CrosshairSprite.global_position = pos


func finish_placing():
	$CrosshairSprite.hide()


func _on_reload_timer_timeout() -> void:
	$ShootAnimation.show()
	$ShootAnimation.play()
	$ShootSound.play()

	await $ShootAnimation.animation_finished

	var base_damage = Data.TOWER_DATA[type]["damage"]
	var final_damage = base_damage

	var crit_chance = Data.TOWER_DATA[type]["crit rate"] / 100.0
	var crit_multiplier = Data.TOWER_DATA[type]["crit damage"] / 100.0

	var is_crit = randf() < crit_chance

	if is_crit:
		final_damage *= 1.0 + crit_multiplier

	shoot.emit(
		$CrosshairSprite.global_position,
		0,
		bullet_type,
		int(final_damage),
		type,
		tower_id
	)

func tower_upgrade():
	$Base.texture = load("res://graphics/towers/mortar/mortar tower upgrade down.png")
