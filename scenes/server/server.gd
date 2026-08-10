extends Button

@onready var area_2d = $IntrusionShield/Shield

var health: float
var max_health: float
var tween = Tween

func _ready() -> void:
	destroy_shield()
	health = Data.ABILITY_DATA[Data.Ability.FIREWALL]['health']
	max_health = health
	Data.deploy_shield.connect(deploy_shield)
	Data.destroy_shield.connect(destroy_shield)
	Data.deploy_deception.connect(deception_active)

func deploy_shield():
	$IntrusionShield/Shield.monitoring = true
	$IntrusionShield.show()


func toggle_particle(state: bool):
	$GPUParticles2D.visible = state

func _on_pressed() -> void:
	get_tree().paused = true
	Data.toggle_server_scene.emit()

func activate_backup_server():
	$BackupServerShield.visible = true

	await play_backup_server_pulse()
	tween = create_tween()
	tween.tween_property($BackupServerShield, "material:shader_parameter/Opaticy", 0, 1.5)
	await get_tree().create_timer(1.5).timeout
	$BackupServerShield.visible = false
	tween.tween_property($BackupServerShield, "material:shader_parameter/Opaticy", 0.155, 0)
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

var attacking_enemies: Dictionary = {} # {enemy_instance: Timer}
var blocked_enemies: Array[Area2D] = []


func _on_shield_area_entered(area: Area2D) -> void:
	# Check if it's an enemy (enemies extend Area2D)
	if area.is_in_group("Enemies"):
		# Block enemy from moving
		if not blocked_enemies.has(area):
			blocked_enemies.append(area)
			area.blocked_by_firewall = true
		
		if not attacking_enemies.has(area):
			# Start attacking by enemy enemy
			var attack_interval = 1.0 / Data.ENEMY_DATA[area.enemy_type_stats]['atkspd']
			var timer = Timer.new()
			timer.wait_time = attack_interval
			timer.one_shot = false
			add_child(timer)
			timer.timeout.connect(_on_enemy_attack.bindv([area]))
			timer.start()
			attacking_enemies[area] = timer


func _on_enemy_attack(enemy: Area2D) -> void:
	# Check if enemy still exists
	if not is_instance_valid(enemy):
		if attacking_enemies.has(enemy):
			attacking_enemies[enemy].queue_free()
			attacking_enemies.erase(enemy)
		return
	
	# Don't attack if enemy is frozen
	if enemy.is_frozen:
		return
	
	# Deal damage
	var damage = Data.ENEMY_DATA[enemy.enemy_type_stats]['damage']
	take_damage(damage)


func take_damage(damage: int) -> void:
	health -= damage
	print("Firewall hit! Health: ", health, "/", max_health)
	
	if health <= 0:
		print("Firewall destroyed!")
	destroy_shield()


func _on_shield_area_exited(area: Area2D) -> void:
	# Check if it's an enemy leaving
	if area.is_in_group("Enemies"):
		# Unblock enemy
		if blocked_enemies.has(area):
			blocked_enemies.erase(area)
			area.blocked_by_firewall = false
		
		if attacking_enemies.has(area):
			var timer = attacking_enemies[area]
			timer.queue_free()
			attacking_enemies.erase(area)

func destroy_shield():
	$IntrusionShield/Shield.monitoring = false
	$IntrusionShield.hide()


func _on_deception_portal_area_entered(area: Area2D) -> void:
	if area.name == "Enemy":
		var enemies = get_tree().get_nodes_in_group("Enemies")
		if enemies:
			for enemy in enemies:
				enemy.teleport_back()

func deception_active(state: bool) -> void:
	$DeceptionDebuff.monitoring = state
	$DeceptionDebuff.visible = state
