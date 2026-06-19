extends Area2D

var path_follow: PathFollow2D
var health: int
var speed: int
var dead := false
var is_worm: bool = false

var dmg_tween: Tween

var history: Array[Vector2] = []
var segments: Array[Node2D] = []
@export var spacing := 64

func _ready() -> void:
	add_to_group('Enemies')
	call_deferred("update_hp_bar_position")
	

func setup(new_path_follow: PathFollow2D, type: Data.Enemy):
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
	
	match Data.ENEMY_DATA[type]['name']:
		"spam":
			$Spam.visible = true
		"adware":
			$Adware.visible = true
		"spyware":
			$Spyware.visible = true
		"creds":
			$Creds.visible = true
		"botnet":
			$Botnet.visible = true
		"worm":
			is_worm = true
			for child in $WormSegments.get_children():
				if child != path_follow:
					segments.append(child)
			$Worm.visible = true

		
	position += Vector2(randi_range(-4, 4), randi_range(-4, 4))
	

func _process(delta: float):
	path_follow.progress += speed * delta
	var head_pos = path_follow.global_position

	history.push_front(head_pos)

	var max_history = segments.size() * spacing
	if history.size() > max_history:
		history.resize(max_history)

	for i in range(segments.size()):
		var index = i * spacing

		if index < history.size():
			$WormSegments.visible = true
			segments[i].global_position = history[index]

			if index + 1 < history.size():
				var dir = history[index] - history[index + 1]
				segments[i].rotation = dir.angle()

		
	if path_follow.progress_ratio >= 0.99:
		Data.health -= 20
		queue_free()


func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit(bullet.damage)


func hit(damage: int = 1):
	if dead:
		return

	flash()
	health -= damage
	$hpbar.value = health
	# ensure an audio stream is present
	if not $AudioStreamPlayer2D.stream:
		$AudioStreamPlayer2D.stream = preload("res://audio/impact.1.ogg")

	show_damage(damage)

	# Non-lethal hit: play locally on the enemy
	if health > 0:
		$AudioStreamPlayer2D.stop()
		$AudioStreamPlayer2D.play(0.0)
		return

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
	var tween = create_tween()

	tween.tween_property($Adware.material, 'shader_parameter/Progress', 1.0, 0.2)
	tween.tween_property($Adware.material, 'shader_parameter/Progress', 0.0, 0.2)
	
	
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
