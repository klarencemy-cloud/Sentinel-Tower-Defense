extends Button

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func toggle_particle(state: bool):
	$GPUParticles2D.visible = state

func _on_pressed() -> void:
	get_tree().paused = true
	Data.toggle_server_scene.emit()

func activate_backup_server():
	$BackupServerShield.visible = true

	await play_backup_server_pulse()

	await get_tree().create_timer(2.0).timeout

	$BackupServerShield.visible = false
	Data.backup_server_invincible = false

func play_backup_server_pulse():
	var pulse = $PulseAnchor/BackupServerPulse
	var sprite = pulse.get_node("Sprite2D")
	var shape = pulse.get_node("CollisionShape2D").shape as CircleShape2D

	pulse.visible = true
	sprite.scale = Vector2.ONE * 0.2
	shape.radius = 5

	var hit_enemies := {}
	pulse.monitoring = true
	var tween = create_tween()
	tween.tween_method(func(radius):
		shape.radius = radius

		for enemy in pulse.get_overlapping_areas():
			if enemy.is_in_group("Enemies") and !hit_enemies.has(enemy):
				hit_enemies[enemy] = true
				enemy.backup_server_knockback()

	, 5.0, 2200.0, 0.8)

	tween.parallel().tween_property(
		sprite,
		"scale",
		Vector2.ONE * 60.0,
		0.8
	)

	await tween.finished
	pulse.monitoring = false
	pulse.visible = false
	shape.radius = 1
