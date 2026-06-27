extends Tower

func _on_reload_timer_timeout() -> void:
	if disabled_by_ad:
		return
	if enemies.size() > 0:
		fire_animation()
		var base_damage = Data.TOWER_DATA[type]["damage"]
		var final_damage = Data.calculate_crit_damage(type, base_damage)
		shoot.emit(position, 0, bullet_type, final_damage, type, tower_id)
		$ShootSound.play()

func fire_animation():
	for particles: GPUParticles2D in $Particles.get_children():
		particles.emitting = true


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/blaster/blaster upgrade.png")
