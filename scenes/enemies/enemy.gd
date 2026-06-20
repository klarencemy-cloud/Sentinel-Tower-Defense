extends Area2D

var path_follow: PathFollow2D
var health: int
var speed: int
var dead := false
var is_worm: bool = false

var dmg_tween: Tween
var enemy_tween: Tween

var enemy_type: Node
var enemy_type_stats: Data.Enemy


@export var spacing := 32

func _ready() -> void:
	add_to_group('Enemies')
	call_deferred("update_hp_bar_position")
	

func setup(new_path_follow: PathFollow2D, type: Data.Enemy):
	enemy_type_stats = type # save enemy type

	$hpbar.max_value = Data.ENEMY_DATA[type]['health']
	path_follow = new_path_follow
	health = Data.ENEMY_DATA[type]['health']
	speed = Data.ENEMY_DATA[type]['speed']
	is_worm = false

	$Spyware.visible = false
	$Adware.visible = false
	$Spam.visible = false
	$Creds.visible = false
	$Botnet.visible = false
	$Worm.visible = false
	$WormSegments.visible = false
	$InsiderThreat.visible = false

	match Data.ENEMY_DATA[type]['name']:
		"spam":
			$Spam.visible = true
			enemy_type = $Spam
			$Spam.material = $Spam.material.duplicate()
		"adware":
			$Adware.visible = true
			enemy_type = $Adware
			$Adware.material = $Adware.material.duplicate()
		"spyware":
			$Spyware.visible = true
			enemy_type = $Spyware
			$Spyware.material = $Spyware.material.duplicate()
		"creds":
			$Creds.visible = true
			enemy_type = $Creds
			$Creds.material = $Creds.material.duplicate()
		"botnet":
			$Botnet.visible = true
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
			
	position += Vector2(randi_range(-4, 4), randi_range(-4, 4))
	

func _process(delta: float):
	path_follow.progress += speed * delta

	if path_follow.progress_ratio >= 0.99:
		Data.health -= 20
		queue_free()


func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit(bullet.damage)


func hit(damage: int = 1, tower_id: int = -1):
	if dead:
		return

	flash()
	health -= damage
	$hpbar.value = health
	# ensure an audio stream is present
	if not $AudioStreamPlayer2D.stream:
		$AudioStreamPlayer2D.stream = preload("res://audio/impact.1.ogg")

	show_damage(damage)

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

	dead = true
	Data.money += 10
	await get_tree().create_timer(0.1).timeout
	queue_free()
	
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
	
func show_damage(damage: int):
	$DamageLabel.text = str(damage)
	$DamageLabel.visible = true
	$DamageLabel.modulate.a = 1
	$DamageLabel.position = Vector2(0, -60)

	# IMPORTANT: kill previous tween
	if dmg_tween:
		dmg_tween.kill()

	dmg_tween = create_tween()
	dmg_tween.tween_property($DamageLabel, "position:y", -90, 0.5)
	dmg_tween.parallel().tween_property($DamageLabel, "modulate:a", 0.0, 0.5)
