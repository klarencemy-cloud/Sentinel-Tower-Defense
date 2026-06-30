extends Tower

func show_crosshair():
	$CrosshairSprite.show()

func crosshair_pos_update(pos: Vector2i):
	$CrosshairSprite.global_position = pos


func finish_placing():
	$CrosshairSprite.hide()


func _on_reload_timer_timeout() -> void:
	if disabled_by_ad or disabled_by_ransomware:
		return
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


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()
