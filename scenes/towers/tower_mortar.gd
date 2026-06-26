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
	var final_damage = Data.calculate_crit_damage(type, base_damage)

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
