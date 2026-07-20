extends Area2D

var path_follow: PathFollow2D
var health: int
var speed: int
var base_speed: int
var dead := false
var is_worm: bool = false
var dmg_tween: Tween
var enemy_tween: Tween
var damage: int
var enemy_type: Node
var enemy_type_stats: Data.Enemy

var is_stunned := false
var is_frozen := false
var is_frozen_vulnerable := false
var stun_timer: Timer
var is_slowed := false
var original_speed: int
var pending_slow_duration: float = 0.0
var invisible: bool = false
var idps_slow_aura := false # For IDPS tier2 passive
var idps_vulnerability_aura := false # For IDPS tier3 passive
var vulnerability_multiplier := 1.0 # Damage multiplier for vulnerabilities
var damage_label_template: Label
var blocked_by_firewall := false # Firewall blocking

var previous_pos: Vector2

const NORMAL_TINT: Color = Color(1, 1, 1, 1)
const SLOWED_TINT: Color = Color(0.6, 0.8, 1.0, 1.0)
const FROZEN_TINT: Color = Color(0.1, 0.2, 0.6, 1.0)

var rootkit_skill_used := false
const ROOTKIT_PORTAL = preload("res://scenes/enemies/rootkit_skill.tscn")
var worm_spawn_timer: Timer
var worm_spawn_interval := 15.0
var can_clone := true
@export var spacing := 32
var spyware_count := 0

var is_ddos_clone := false
const DDOS_HEALTH_MULTIPLIER := 0.35 # 35% HP

var hostile := false
var hostile_count := 0


@onready var hit_particles: GPUParticles2D = $HitParticles

func _ready() -> void:
	add_to_group('Enemies')
	damage_label_template = $DamageLabel.duplicate() as Label
	damage_label_template.visible = false
	$DamageLabel.queue_free()
	call_deferred("update_hp_bar_position")
	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.wait_time = 0.5
	stun_timer.timeout.connect(_on_stun_end)
	add_child(stun_timer)
	
	worm_spawn_timer = Timer.new()
	worm_spawn_timer.one_shot = false
	worm_spawn_timer.wait_time = worm_spawn_interval
	worm_spawn_timer.timeout.connect(_spawn_worm_clone)
	add_child(worm_spawn_timer)
	
	if enemy_type_stats == Data.Enemy.WORM:
		worm_spawn_timer.start()
	

func setup(new_path_follow: PathFollow2D, type: Data.Enemy):
	enemy_type_stats = type # save enemy type

	$hpbar.max_value = Data.ENEMY_DATA[type]['health']
	$hpbar.value = Data.ENEMY_DATA[type]['health']
	path_follow = new_path_follow
	previous_pos = path_follow.global_position
	path_follow.rotation = 0.0
	

	health = Data.ENEMY_DATA[type]['health']
	speed = Data.ENEMY_DATA[type]['speed']
	base_speed = speed
	damage = Data.ENEMY_DATA[type]['damage']
	is_worm = false
	
	$SpywareAbility.monitoring = false
	$SpywareAbility.monitorable = false
	$SpywareAbility/SpywareAbilityRange.disabled = true
	$SpywareAbility.visible = false
	
	$BotnetAbility.monitoring = false
	$BotnetAbility.monitorable = false
	$BotnetAbility/BotnetAbilityRange.disabled = true
	$BotnetAbility.visible = false
	
	$VirusAbility.monitoring = false
	$VirusAbility.monitorable = false
	$VirusAbility/VirusAbilityRange.disabled = true
	$VirusAbility.visible = false
	
	$Spam.visible = false
	$Virus.visible = false
	$Spyware.visible = false
	$Adware.visible = false
	$Trojan.visible = false
	$Creds.visible = false
	$Botnet.visible = false
	$Worm.visible = false
	$WormSegments.visible = false
	$InsiderThreat.visible = false
	$Rootkit.visible = false
	$SQL.visible = false
	$DDOS.visible = false
	$Ransomware.visible = false
	$Zero.visible = false
	$Boss1.visible = false
	$Boss2.visible = false
	$Boss3.visible = false
	$Boss4.visible = false
	$Boss5.visible = false

	match Data.ENEMY_DATA[type]['name']:
		"spam":
			$Spam.visible = true
			enemy_type = $Spam
			$Spam.material = $Spam.material.duplicate()
		"virus":
			$Virus.visible = true
			enemy_type = $Virus
			$Virus.material = $Virus.material.duplicate()
			$VirusAbility.monitoring = true
			$VirusAbility.monitorable = true
			$VirusAbility/VirusAbilityRange.disabled = false
			$VirusAbility.visible = true
		"adware":
			$Adware.visible = true
			enemy_type = $Adware
			$Adware.material = $Adware.material.duplicate()
			_update_active_enemy_counter(Data.Enemy.ADWARE, 1)
		"spyware":
			$Spyware.visible = true
			$SpywareAbility.monitoring = true
			$SpywareAbility.monitorable = true
			$SpywareAbility/SpywareAbilityRange.disabled = false
			enemy_type = $Spyware
			$Spyware.material = $Spyware.material.duplicate()
			$SpywareAbility.visible = true
		"trojan":
			$Trojan.visible = true
			enemy_type = $Trojan
			$Trojan.material = $Trojan.material.duplicate()
		"creds":
			$Creds.visible = true
			enemy_type = $Creds
			$Creds.material = $Creds.material.duplicate()
		"botnet":
			$Botnet.visible = true
			$BotnetAbility.monitoring = true
			$BotnetAbility.monitorable = true
			$BotnetAbility/BotnetAbilityRange.disabled = false
			$BotnetAbility.visible = true
			enemy_type = $Botnet
			$Botnet.material = $Botnet.material.duplicate()
		"worm":
			is_worm = true
			$Worm.visible = true
			enemy_type = $Worm
			$Worm.material = $Worm.material.duplicate()
			$WormSegments.visible = true
			
			for child in $WormSegments.get_children():
					child.material = child.material.duplicate()
			
		"insiderthreat":
			$InsiderThreat.visible = true
			enemy_type = $InsiderThreat
			$InsiderThreat.material = $InsiderThreat.material.duplicate()
			set_invisible(true)
		"rootkit":
			$Rootkit.visible = true
			enemy_type = $Rootkit
			$Rootkit.material = $Rootkit.material.duplicate()
		"sql":
			$SQL.visible = true
			enemy_type = $SQL
			$SQL.material = $SQL.material.duplicate()
		"ddos":
			$DDOS.visible = true
			enemy_type = $DDOS
			$DDOS.material = $DDOS.material.duplicate()
		"ransomware":
			$Ransomware.visible = true
			enemy_type = $Ransomware
			$Ransomware.material = $Ransomware.material.duplicate()
			_update_active_enemy_counter(Data.Enemy.RANSOMWARE, 1)
		"zero":
			$Zero.visible = true
			enemy_type = $Zero
			$Zero.material = $Zero.material.duplicate()
		"boss1":
			$Boss1.visible = true
			enemy_type = $Boss1
			$Boss1.material = $Boss1.material.duplicate()
			print("Boss1 spawned, starting virus timer")
			$hpbar.visible = false
			call_deferred("_start_boss1_spawn_timer")
			
		"boss2":
			$Boss2.visible = true
			enemy_type = $Boss2
			$Boss2.material = $Boss2.material.duplicate()
			print("Boss2 spawned, starting botnet timer")
			$hpbar.visible = false
			call_deferred("_start_boss2_spawn_timer")
		"boss3":
			$Boss3.visible = true
			enemy_type = $Boss3
			$Boss3.material = $Boss3.material.duplicate()
			$hpbar.visible = false
			call_deferred("_boss3_stun_loop")
			
		"boss4":
			$Boss4.visible = true
			enemy_type = $Boss4
			$Boss4.material = $Boss4.material.duplicate()
			$hpbar.visible = false
		"boss5":
			$Boss5.visible = true
			enemy_type = $Boss5
			$Boss5.material = $Boss5.material.duplicate()
			$hpbar.visible = false
			call_deferred("_boss5_spawn_loop")
			
	position += Vector2(randi_range(-4, 4), randi_range(-4, 4))

	if enemy_type != $Worm:
		path_follow.rotates = false
	
	if enemy_type_stats in [
		Data.Enemy.BOSS1,
		Data.Enemy.BOSS2,
		Data.Enemy.BOSS3,
		Data.Enemy.BOSS4,
		Data.Enemy.BOSS5
	]:
		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.update_boss_hp(enemy_type_stats, health, health)
		

func _process(delta: float):
	if is_stunned or blocked_by_firewall:
		return
	
	var current_speed = speed
	
	# Apply IDPS tier2 slow aura (15% slower = 85% speed)
	if idps_slow_aura:
		current_speed = int(speed * 0.85)
	# Apply regular slow effect
	elif is_slowed:
		current_speed = int(speed * 0.5) # 50% speed when slowed
		
	path_follow.progress += current_speed * delta
	
	if enemy_type_stats == Data.Enemy.ROOTKIT and !rootkit_skill_used:
		if path_follow.progress_ratio >= randf_range(0.2, 0.3):
			rootkit_skill_used = true
			spawn_rootkit_portal()
	
	if enemy_type_stats == Data.Enemy.SPYWARE:
		update_spyware_buff()
		
	if enemy_type == $Worm and Data.current_wave == 12 and !GameDialogueManager.is_level2_worm2_shown:
		GameDialogueManager.show_dialogue_level2_worm2()

	if enemy_type != $Worm:
		var current_pos = path_follow.global_position
		var dir = current_pos - previous_pos
		var margin = 1
	
		if abs(dir.x) > abs(dir.y) + margin:
			if dir.x > 1:
				enemy_type.flip_h = false
				enemy_type.play("Right_Hostile" if hostile_count > 0 else "Right")
			elif dir.x < -1:
				if enemy_type.sprite_frames.has_animation("Left"):
					enemy_type.play("Left")
				else:
					enemy_type.play("Right_Hostile" if hostile_count > 0 else "Right")
					enemy_type.flip_h = true
		elif abs(dir.x) < abs(dir.y) + margin:
			if dir.y > 1:
				if enemy_type.sprite_frames.has_animation("Down"):
					enemy_type.play("Down_Hostile" if hostile_count > 0 else "Down")
				else:
					enemy_type.play("Right_Hostile" if hostile_count > 0 else "Right")
			elif dir.y < -1:
				if enemy_type.sprite_frames.has_animation("Up"):
					enemy_type.play("Up")
				else:
					enemy_type.play("Right_Hostile" if hostile_count > 0 else "Right")

		previous_pos = current_pos
	

	if path_follow.progress_ratio >= 0.99:
		var processed_enemy_damage: float = 0.0
		var raw_dmg = damage
		processed_enemy_damage = Defense._dmg_reduc_armor(raw_dmg) # sends dmg to defense_data.gd to reduc dmg based on armor
		if !Data.backup_server_invincible:
			Data.health -= processed_enemy_damage
		_update_active_enemy_counter(enemy_type_stats, -1)
		queue_free()
	if enemy_type_stats == Data.Enemy.SPYWARE:
		pass # skip the spyware itself

	if spyware_count > 0:
		print(name, speed)

##func _on_area_entered(bullet: Area2D) -> void:
##	bullet.queue_free()
##	hit(bullet.damage)
## RESPONSIBLE FOR DOUBLE DAMAGE BUG (I THINK)


func emit_hit_particles(angle: float):
	hit_particles.rotation = angle

func hit(damage: int = 1, tower_id: int = -1):
	if dead:
		return
	
	hit_particles.restart()
	hit_particles.emitting = true

	print("HIT", damage, " frame:", Engine.get_process_frames())
	damage = int(round(damage * Offense.multiplied_total_dmg))
	var actual_damage: int = damage
	print("MULTIPLIED DMG: " + str(actual_damage))
	if is_frozen and is_frozen_vulnerable:
		actual_damage = int(ceil(damage * 10))
	
	# Apply vulnerability multiplier (e.g., IDPS tier3)
	actual_damage = int(actual_damage * vulnerability_multiplier)

	flash()
	health -= actual_damage
	$hpbar.value = health
	
	if enemy_type_stats in [
		Data.Enemy.BOSS1,
		Data.Enemy.BOSS2,
		Data.Enemy.BOSS3,
		Data.Enemy.BOSS4,
		Data.Enemy.BOSS5
	]:
		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.update_boss_hp(
				enemy_type_stats,
				health,
				Data.ENEMY_DATA[enemy_type_stats]["health"]
			)
	# ensure an audio stream is present
	if not $AudioStreamPlayer2D.stream:
		$AudioStreamPlayer2D.stream = preload("res://audio/impact.1.ogg")

	if enemy_type == $Boss1: # to check the health of boss1 for dialogue
		if Data.current_wave == 10 and !Data.is_sandbox and !GameDialogueManager.is_boss1_defeated:
			if health <= 0:
				GameDialogueManager.show_dialogue_boss1_defeated()

	if enemy_type == $Boss2: # to check the health of boss2 for dialogue
		if Data.current_wave == 20 and !Data.is_sandbox and !GameDialogueManager.is_leve2_boss2_hp_shown:
			if health < (float(Data.ENEMY_DATA[Data.Enemy.BOSS2]["health"]) / 2):
				GameDialogueManager.show_dialogue_level2_boss2_hp()
		elif Data.current_wave == 20 and !Data.is_sandbox and !GameDialogueManager.is_level2_boss2_defeated:
			if health <= 0:
				GameDialogueManager.show_dialogue_level2_boss2_defeated()

	if enemy_type == $Boss3: # to check the health of boss3 for dialogue
		if Data.current_wave == 30 and !Data.is_sandbox and !GameDialogueManager.is_boss3_hp_shown:
			if health < (float(Data.ENEMY_DATA[Data.Enemy.BOSS2]["health"]) / 2):
				GameDialogueManager.show_dialogue_level3_boss3_hp()
		elif Data.current_wave == 30 and !Data.is_sandbox and !GameDialogueManager.is_boss3_defeated:
			if health <= 0:
				GameDialogueManager.show_dialogue_level3_boss3_defeated()

	if enemy_type == $Boss4: # to check the health of boss4 for dialogue
		if Data.current_wave == 40 and !Data.is_sandbox and !GameDialogueManager.is_boss4_hp_shown:
			if health < (float(Data.ENEMY_DATA[Data.Enemy.BOSS2]["health"]) / 2):
				GameDialogueManager.show_dialogue_level4_boss4_hp()
		elif Data.current_wave == 40 and !Data.is_sandbox and !GameDialogueManager.is_boss4_defeated_shown:
			if health <= 0:
				GameDialogueManager.show_dialogue_level4_boss4_defeated()
	
	if enemy_type == $Boss5: # to check the health of boss5 for dialogue
		if Data.current_wave == 50 and !Data.is_sandbox and !GameDialogueManager.is_level5_boss5_hp_shown:
			if health < (float(Data.ENEMY_DATA[Data.Enemy.BOSS2]["health"]) / 2):
				GameDialogueManager.show_dialogue_level5_boss5_hp()
		elif Data.current_wave == 50 and !Data.is_sandbox and !GameDialogueManager.is_level5_boss5_defeated_shown:
			if health <= 0:
				GameDialogueManager.show_dialogue_level5_boss5_defeated()

	if enemy_type == $Boss6: # to check the health of boss5 for dialogue
		if Data.current_wave == 51 and !Data.is_sandbox and !GameDialogueManager.is_level6_boss6_hp_shown:
			if health < (float(Data.ENEMY_DATA[Data.Enemy.BOSS2]["health"]) / 2):
				GameDialogueManager.show_dialogue_level6_boss6_hp()
		elif Data.current_wave == 51 and !Data.is_sandbox and !GameDialogueManager.is_level6_boss6_defeated_shown:
			if health <= 0:
				GameDialogueManager.show_dialogue_level6_boss6_defeated()

	show_damage(actual_damage)

	#Give damage in damage global data
	if tower_id != -1:
		EnemyTower.add_damage(tower_id, damage)

	# Non-lethal hit: play locally on the enemy
	if health > 0:
		$AudioStreamPlayer2D.stop()
		$AudioStreamPlayer2D.play(0.0)
		return

	EnemyStats.add_kill(enemy_type_stats)
	# Lethal hit: detach the audio player so it keeps playing after this node is freed
	var audio = $AudioStreamPlayer2D
	# make sure stream exists on the node
	if not audio.stream:
		audio.stream = preload("res://audio/impact.1.ogg")
	# remove from this enemy and reparent to the scene root (viewport)
	var parent = audio.get_parent()
	parent.remove_child(audio)
	get_tree().get_root().add_child(audio)
	audio.global_position = global_position
	audio.stop()
	audio.play(0.0)
	# schedule the detached audio to be freed after a short delay
	get_tree().create_timer(2.0).connect("timeout", Callable(audio, "queue_free"))

	_update_active_enemy_counter(enemy_type_stats, -1)
	if enemy_type_stats == Data.Enemy.DDOS and !is_ddos_clone:
		dead = true
		$CollisionShape2D.disabled = true
		speed = 0
		if enemy_type:
			enemy_type.stop()
		await get_tree().create_timer(1.5).timeout
		var wave_manager = get_tree().get_first_node_in_group("WaveManager")
		if wave_manager:
			wave_manager.spawn_ddos_clones(
				path_follow.get_parent(),
				path_follow.progress
			)
	dead = true
	Data.money += int(round(10 * Economy.gold_multiplier)) # update money
	if enemy_type_stats in [
		Data.Enemy.BOSS1,
		Data.Enemy.BOSS2,
		Data.Enemy.BOSS3,
		Data.Enemy.BOSS4,
		Data.Enemy.BOSS5
	]:
		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.boss_hp_bar.visible = false
	Data.experience += Data.ENEMY_DATA[enemy_type_stats]["exp"] * Economy.exp_multiplier # update exp points
	await get_tree().create_timer(0.1).timeout
	queue_free()
	
func _update_active_enemy_counter(enemy_type: Data.Enemy, delta: int) -> void:
	if enemy_type == Data.Enemy.ADWARE:
		Data.active_adware = max(0, Data.active_adware + delta)
		Data.active_adware_changed.emit()
	elif enemy_type == Data.Enemy.RANSOMWARE:
		Data.active_ransomware = max(0, Data.active_ransomware + delta)
		Data.active_ransomware_changed.emit()

func flash():
	if enemy_tween:
		enemy_tween.kill()

	enemy_tween = create_tween()
	enemy_tween.tween_property(enemy_type.material, 'shader_parameter/Progress', 1.0, 0.2)
	if is_worm:
		enemy_tween.parallel().tween_property($WormSegments/Body1.material, 'shader_parameter/Progress', 1.0, 0.2)
		enemy_tween.parallel().tween_property($WormSegments/Body2.material, 'shader_parameter/Progress', 1.0, 0.2)
		enemy_tween.parallel().tween_property($WormSegments/Tail.material, 'shader_parameter/Progress', 1.0, 0.2)
		enemy_tween.tween_property($WormSegments/Body1.material, 'shader_parameter/Progress', 0.0, 0.2)
		enemy_tween.parallel().tween_property($WormSegments/Body2.material, 'shader_parameter/Progress', 0.0, 0.2)
		enemy_tween.parallel().tween_property($WormSegments/Tail.material, 'shader_parameter/Progress', 0.0, 0.2)
	enemy_tween.tween_property(enemy_type.material, 'shader_parameter/Progress', 0.0, 0.2)
	
	
func update_hp_bar_position():
	for child in get_children():
		if child is AnimatedSprite2D and child.visible:
			var tex = child.sprite_frames.get_frame_texture(
				child.animation,
				child.frame
			)
			var sprite_height = tex.get_height() * child.scale.y
			$hpbar.position.y = - sprite_height / 2 - 10
			
			if enemy_type_stats in [
				Data.Enemy.BOSS1,
				Data.Enemy.BOSS2,
				Data.Enemy.BOSS3,
				Data.Enemy.BOSS4,
				Data.Enemy.BOSS5
			]:
				$hpbar.position.y -= 70

func set_invisible(value: bool) -> void:
	invisible = value
	if enemy_type_stats == Data.Enemy.INSIDERTHREAT and enemy_type:
		enemy_type.modulate.a = 0.3 if invisible else 1.0
		$CollisionShape2D.disabled = invisible

func show_damage(damage: int):
	var label = damage_label_template.duplicate() as Label
	label.name = "DamageLabelPopup"
	print("SHOW DAMAGE:", damage)
	label.text = str(damage)
	label.visible = true
	label.modulate.a = 1.0
	label.position = Vector2(
		randi_range(-10, 10),
		-60 + randi_range(-5, 5)
	)

	add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y - 30, 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)

	await tween.finished
	label.queue_free()
	
func stun(duration: float = 0.5, vulnerable: bool = false):
	is_stunned = true
	is_frozen = true
	is_frozen_vulnerable = vulnerable
	if enemy_type:
		enemy_type.modulate = FROZEN_TINT
	stun_timer.wait_time = duration
	stun_timer.start()

func stun_then_slow(stun_duration: float = 0.5, slow_duration: float = 2.0, vulnerable: bool = false):
	pending_slow_duration = slow_duration
	stun(stun_duration, vulnerable)

func slow(duration: float = 2.0):
	is_slowed = true
	if enemy_type and not is_frozen:
		enemy_type.modulate = SLOWED_TINT
	await get_tree().create_timer(duration).timeout
	is_slowed = false
	if enemy_type and not is_frozen:
		enemy_type.modulate = NORMAL_TINT

func _on_stun_end():
	is_stunned = false
	is_frozen = false
	is_frozen_vulnerable = false
	if enemy_type:
		if pending_slow_duration > 0.0:
			enemy_type.modulate = SLOWED_TINT
		else:
			enemy_type.modulate = NORMAL_TINT
	if pending_slow_duration > 0.0:
		slow(pending_slow_duration)
		pending_slow_duration = 0.0

func spawn_rootkit_portal():
	var entrance = ROOTKIT_PORTAL.instantiate()
	var exit = ROOTKIT_PORTAL.instantiate()

	get_tree().current_scene.add_child(entrance)
	get_tree().current_scene.add_child(exit)

	# Entrance
	entrance.global_position = path_follow.global_position
	entrance.is_exit = false

	# Exit (10% ahead)
	var path := path_follow.get_parent()
	var exit_progress = path_follow.progress + path.curve.get_baked_length() * 0.15

	var temp := PathFollow2D.new()
	path.add_child(temp)
	temp.progress = exit_progress
	exit.global_position = temp.global_position
	temp.queue_free()

	exit.is_exit = true

	# Tell the entrance where to send enemies
	entrance.exit_progress = exit_progress

func _spawn_worm_clone():
	if dead or !can_clone:
		return

	var wave_manager = get_tree().get_first_node_in_group("WaveManager")
	if wave_manager:
		wave_manager.spawn_worm_clone(
			path_follow.get_parent(),
			path_follow.progress - spacing
		)


func _on_spyware_ability_area_entered(area: Area2D) -> void:
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower
		tower.spyware_count += 1

		if tower.spyware_count == 1:
			var shape = tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
			shape.radius = max(shape.radius - 50, 10)


func _on_spyware_ability_area_exited(area: Area2D) -> void:
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower

		tower.spyware_count -= 1

		if tower.spyware_count == 0:
			var shape := tower.get_node("EnemyDetectionArea/CollisionShape2D").shape as CircleShape2D
			shape.radius += 50

func update_spyware_buff():
	for area in $SpywareAbility.get_overlapping_areas():
		if !area.is_in_group("Enemies"):
			continue

		if area == self:
			continue

		if area.enemy_type_stats == Data.Enemy.SPYWARE:
			continue

		area.speed = area.base_speed * 1.15
		area.damage = Data.ENEMY_DATA[area.enemy_type_stats]["damage"] + 10

	var buffed = []
	for area in $SpywareAbility.get_overlapping_areas():
		if !area.is_in_group("Enemies"):
			continue
		if area == self:
			continue
		if area.enemy_type_stats == Data.Enemy.SPYWARE:
			continue

		buffed.append(area)
		area.speed = area.base_speed * 1.15
		area.damage = Data.ENEMY_DATA[area.enemy_type_stats]["damage"] + 10

	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy == self:
			continue
		if enemy.enemy_type_stats == Data.Enemy.SPYWARE:
			continue
		if enemy in buffed:
			continue

		enemy.speed = enemy.base_speed
		enemy.damage = Data.ENEMY_DATA[enemy.enemy_type_stats]["damage"]


func _on_bot_net_ability_area_entered(area):
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower
		tower.botnet_count += 1


func _on_bot_net_ability_area_exited(area):
	if area.name == "ClickArea":
		var tower = area.get_parent() as Tower
		tower.botnet_count -= 1
		tower.botnet_count = max(tower.botnet_count, 0)


func _on_virus_ability_area_entered(area):
	if area.name == "ClickArea":
		var tower = area.get_parent()

		if tower.virus_count == 0:
			tower.reload_time = tower.original_reload_time * 1.25
		tower.virus_count += 1

func _on_virus_ability_area_exited(area):
	if area.name == "ClickArea":
		var tower = area.get_parent()

		tower.virus_count -= 1

		if tower.virus_count <= 0:
			tower.virus_count = 0
			tower.reload_time = tower.original_reload_time

func _start_boss1_spawn_timer() -> void:
	if is_queued_for_deletion():
		return

	var timer: Timer = $Boss1/SpawnVirusTimer
	if timer:
		timer.start()
		print("Started boss1 timer:", timer.is_stopped())
		print("Time left:", timer.time_left)

func _start_boss2_spawn_timer() -> void:
	if is_queued_for_deletion():
		return

	var timer: Timer = $Boss2/SpawnBotnetTimer
	if timer:
		timer.start()
		print("Started boss2 timer:", timer.is_stopped())
		print("Time left:", timer.time_left)

func _on_spawn_virus_timer_timeout():
	print("Boss spawn timer timeout")
	var wave_manager = get_tree().get_first_node_in_group("WaveManager")
	if not wave_manager:
		print("WaveManager NOT found")
		return

	if enemy_type_stats == Data.Enemy.BOSS1:
		print("Boss1 spawn timer fired")
		wave_manager.spawn_boss_viruses()
	elif enemy_type_stats == Data.Enemy.BOSS2:
		print("Boss2 spawn timer fired")
		wave_manager.spawn_boss_botnets()

func _boss3_stun_loop() -> void:
	while !dead and enemy_type_stats == Data.Enemy.BOSS3:
		await get_tree().create_timer(3.0).timeout

		if dead or is_queued_for_deletion():
			break

		var towers = get_tree().get_nodes_in_group("Towers")
		if towers.is_empty():
			continue

		var tower = towers.pick_random()
		if !tower.stunned:
			tower.apply_boss3_stun(5.0)

func _boss5_spawn_loop():
	while !dead and enemy_type_stats == Data.Enemy.BOSS5:
		await get_tree().create_timer(2.0).timeout

		if dead or is_queued_for_deletion():
			break

		var wave_manager = get_tree().get_first_node_in_group("WaveManager")
		if wave_manager:
			wave_manager.spawn_boss5_wave()

func backup_server_knockback():
	if dead:
		return

	path_follow.progress_ratio = max(path_follow.progress_ratio - 0.2, 0.0)
	previous_pos = path_follow.global_position
