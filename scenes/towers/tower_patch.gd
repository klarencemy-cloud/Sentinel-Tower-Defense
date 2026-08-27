extends Tower
@onready var sound_particles: AudioStreamPlayer2D = $Particle
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0


func _process(_delta: float) -> void:
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI / 2
func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if enemies.size() > 0:
		var fire_rotation = $Turret.rotation

		# Botnet effect
		if botnet_count > 0:
			var spread = min(botnet_count * 10.0, 45.0)
			fire_rotation += deg_to_rad(randf_range(-spread, spread))

		var dir = Vector2.DOWN.rotated(fire_rotation).normalized()
		var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)

		shoot.emit(
			position + dir * 16,
			fire_rotation,
			bullet_type,
			final_damage,
			type,
			tower_id,
			enemies[0] # <-- target
		)
		# fire_animation()
		$ShootSound.play()

func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


# func fire_animation():
# 	for particles: GPUParticles2D in $Turret/Particles.get_children():
# 		particles.restart()
# 		particles.emitting = true
# 		sound_particles.play()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
