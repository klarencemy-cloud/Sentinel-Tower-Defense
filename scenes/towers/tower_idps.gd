extends Tower


func _process(_delta: float) -> void:
	# Apply passive auras to enemies in range
	var tower_data = Data.TOWER_DATA.get(type, null)
	if not tower_data:
		return
	
	var tier2_unlocked = tower_data.get('tier2abilityunlocked', false)
	var tier3_unlocked = tower_data.get('tier3abilityunlocked', false)
	var detection_range = Data.TOWER_DATA[type]["range"]
	
	# Apply auras to all enemies
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var in_range = position.distance_to(enemy.global_position) < detection_range
		
		# Tier 2: Slow Pulse - 15% slower
		if tier2_unlocked and in_range:
			enemy.idps_slow_aura = true
		else:
			enemy.idps_slow_aura = false
		
		# Tier 3: Vulnerability Pulse - 15% more damage taken
		if tier3_unlocked and in_range:
			enemy.idps_vulnerability_aura = true
			enemy.vulnerability_multiplier = 1.15
		else:
			enemy.idps_vulnerability_aura = false
			enemy.vulnerability_multiplier = 1.0


func _on_reload_timer_timeout() -> void:
	# Get all visible enemies in range
	var valid_enemies = enemies.size()
	
	# IDPS also detects invisible enemies
	var detection_range = Data.TOWER_DATA[type]["range"]
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.invisible and position.distance_to(enemy.global_position) < detection_range:
			valid_enemies += 1
	
	if valid_enemies > 0:
		fire_animation()
		var damage = Data.TOWER_DATA[type]["damage"]
		shoot.emit(position, 0, bullet_type, damage, type, tower_id)
		$ShootSound.play()

func fire_animation():
	for particles: GPUParticles2D in $Particles.get_children():
		particles.emitting = true


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/blaster/blaster upgrade.png")
