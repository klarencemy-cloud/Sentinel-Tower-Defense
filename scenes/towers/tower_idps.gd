extends Tower
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0

func _process(_delta: float) -> void:
	var idps_towers := []
	for tower in get_tree().get_nodes_in_group("towers"):
		if tower.type == Data.Tower.IDPS:
			idps_towers.append(tower)

	if idps_towers.is_empty():
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			enemy.idps_slow_aura = false
			enemy.idps_vulnerability_aura = false
			enemy.vulnerability_multiplier = 1.0
		return

	if idps_towers[0] != self:
		return

	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var slow_active := false
		var vulnerability_multiplier := 1.0
		for tower in idps_towers:
			var tower_data = Data.TOWER_DATA[tower.type]
			if tower.position.distance_to(enemy.global_position) >= tower.range:
				continue
			slow_active = slow_active or tower_data.get("tier2abilityunlocked", false)
			if tower_data.get("tier3abilityunlocked", false):
				vulnerability_multiplier = max(vulnerability_multiplier, 1.15)

		enemy.idps_slow_aura = slow_active
		enemy.idps_vulnerability_aura = vulnerability_multiplier > 1.0
		enemy.vulnerability_multiplier = vulnerability_multiplier


func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return
	# Get all visible enemies in range
	var valid_enemies = enemies.size()
	
	# IDPS also detects invisible enemies
	var detection_range = Data.TOWER_DATA[type]["range"]
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.invisible and position.distance_to(enemy.global_position) < detection_range:
			valid_enemies += 1
	
	if valid_enemies > 0:
		fire_animation()
		var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
		shoot.emit(position, 0, bullet_type, final_damage, type, tower_id)
		$ShootSound.play()

func fire_animation():
	for particles: GPUParticles2D in $Particles.get_children():
		particles.emitting = true


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/blaster/blaster upgrade.png")


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
