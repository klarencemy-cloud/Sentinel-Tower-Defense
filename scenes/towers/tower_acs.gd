extends Tower

var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0

func _process(_delta: float) -> void:
	var acs_towers := []
	for tower in get_tree().get_nodes_in_group("towers"):
		if tower.type == Data.Tower.ACCESS_CONTROL_SYSTEM:
			acs_towers.append(tower)

	if acs_towers.is_empty():
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			enemy.acs_in_range = false
			enemy.acs_slow_multiplier = 1.0
		return

	if acs_towers[0] != self:
		return

	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var in_range := false
		var slow_multiplier := 1.0
		var has_lockdown := false
		for tower in acs_towers:
			if tower.position.distance_to(enemy.global_position) < tower.range:
				in_range = true
				var tower_data = Data.TOWER_DATA[tower.type]
				if tower_data.get("tier2abilityunlocked", false):
					slow_multiplier = min(slow_multiplier, 0.55)
				elif tower_data.get("tier1abilityunlocked", false):
					slow_multiplier = min(slow_multiplier, 0.65)
				else:
					slow_multiplier = min(slow_multiplier, 0.8)
				has_lockdown = has_lockdown or tower_data.get("tier3abilityunlocked", false)

		if in_range and not enemy.acs_in_range and has_lockdown:
			enemy.acs_lockdown_remaining = 3.0
		enemy.acs_in_range = in_range
		enemy.acs_slow_multiplier = slow_multiplier if in_range else 1.0

func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return
	# Get all visible enemies in range
	var valid_enemies = enemies.size()
	
	if valid_enemies > 0:
		var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
		shoot.emit(position, 0, bullet_type, final_damage, type, tower_id)
		$ShootSound.play()
		fire_animation()

func fire_animation():
	for particles: GPUParticles2D in $Particles.get_children():
		particles.restart()
		particles.emitting = true

func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
