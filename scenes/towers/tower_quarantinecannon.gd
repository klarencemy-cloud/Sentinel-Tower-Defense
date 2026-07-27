extends Tower

func _process(_delta):
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI / 2


func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if enemies.is_empty():
		return

	$Turret/ShootAnimation.show()
	$Turret/ShootAnimation2.show()
	$Turret/ShootAnimation.play()
	$Turret/ShootAnimation2.play()
	$ShootSound.play()

	# await $Turret/ShootAnimation.animation_finished

	# Enemy may have died during the animation
	if enemies.is_empty():
		return

	var base_damage = Data.TOWER_DATA[type]["damage"]
	var final_damage = Data.calculate_crit_damage(type, base_damage)

	shoot_mortar.emit(
	$Turret.global_position,
	enemies[0], # pass the enemy
	int(final_damage),
	type,
	tower_id
	)


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()
