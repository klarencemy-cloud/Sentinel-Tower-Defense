extends Tower

const MALWARE_TYPES = [Data.Enemy.VIRUS, Data.Enemy.WORM, Data.Enemy.TROJAN]

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
		
		final_damage = _apply_antivirus_bonus(final_damage, enemies[0])
		
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


# Increased damage against malware (Virus, Worm, Trojan)
func _apply_antivirus_bonus(base_dmg: int, target_enemy: Area2D) -> int:
	if not target_enemy.enemy_type_stats in MALWARE_TYPES:
		return base_dmg
	
	var bonus_multiplier := 1.2 # passive: 20%
	
	var tower_data = Data.TOWER_DATA.get(type, {})
	
	if tower_data.get("tier3abilityunlocked", false):
		bonus_multiplier = 1.5 # T350%
	elif tower_data.get("tier2abilityunlocked", false):
		bonus_multiplier = 1.4 # T2 40%
	elif tower_data.get("tier1abilityunlocked", false):
		bonus_multiplier = 1.3 # T13 0%
	
	return int(round(base_dmg * bonus_multiplier))


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")


func _on_pay_button_pressed() -> void:
	if Data.money < 50:
		return

	Data.money -= 50
	remove_ransomware()