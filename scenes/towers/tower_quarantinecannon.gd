extends Tower
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0
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

	var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)
	var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)

	shoot_mortar.emit(
	$Turret.global_position,
	enemies[0], # pass the enemy
	int(final_damage),
	type,
	tower_id
	)


func _on_pay_button_pressed() -> void:
	var ransom_cost: int = currentserverload * 5
	if Data.money < ransom_cost:
		return

	Data.money -= ransom_cost
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
