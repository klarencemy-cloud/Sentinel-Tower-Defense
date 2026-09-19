extends Tower
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0
func get_damage_reduction_multiplier() -> float:
	if Data.TOWER_DATA[type].get("tier1abilityunlocked", false):
		return 0.50
	return 0.65

func is_tier2_unlocked() -> bool:
	return Data.TOWER_DATA[type].get("tier2abilityunlocked", false)

func is_tier3_unlocked() -> bool:
	return Data.TOWER_DATA[type].get("tier3abilityunlocked", false)

func on_bullet_hit_enemy(enemy: Area2D) -> void:
	var dmg_mult = get_damage_reduction_multiplier()
	var was_already_debuffed = enemy.dlp_damage_reduction < 1.0
	enemy.apply_dlp_damage_reduction(dmg_mult)
	enemy.flash_dlp_debuff()
	
	if was_already_debuffed and is_tier2_unlocked():
		var spread_target = _spread_debuff(enemy, dmg_mult)
		if spread_target != null:
			spread_target.flash_dlp_debuff()

func _spread_debuff(from_enemy: Area2D, dmg_mult: float) -> Area2D:
	var spread_range = 400
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var nearest_dist = INF
	
	for e in enemies:
		if e == from_enemy:
			continue
		if e.dlp_damage_reduction <= dmg_mult:
			continue
		var dist = from_enemy.global_position.distance_to(e.global_position)
		if dist > spread_range:
			continue
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = e
	
	if nearest != null:
		nearest.apply_dlp_damage_reduction(dmg_mult)
	
	return nearest

func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if enemies:
		var target = enemies[0]
		var dir = (target.global_position - global_position).normalized()
		var fire_rotation = Vector2.DOWN.angle_to(dir)
		fire_rotation = get_botnet_fire_rotation(fire_rotation)

		var base_damage = damage + (damage * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
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
	var ransom_cost: int = currentserverload * 5
	if Data.money < ransom_cost:
		return

	Data.money -= ransom_cost
	remove_ransomware()

	
func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
