extends Area2D

var target: Area2D
var damage: int
var tower_type
var tower_id
var speed := 600
var direction := Vector2.ZERO
var turn_speed := 8.0

func setup(start_pos, target_enemy, new_damage, _tower_type, _tower_id):
	global_position = start_pos
	target = target_enemy
	damage = new_damage
	tower_type = _tower_type
	tower_id = _tower_id
	direction = (target.global_position - global_position).normalized()


func _process(delta):
	if !is_instance_valid(target):
		explode()
		return

	var to_target = target.global_position - global_position

	# Close enough? Explode immediately.
	if to_target.length() <= speed * delta:
		global_position = target.global_position
		explode()
		return

	var desired = to_target.normalized()

	direction = direction.rotated(
		clamp(
			direction.angle_to(desired),
			-turn_speed * delta,
			turn_speed * delta
		)
	)

	global_position += direction * speed * delta
	rotation = direction.angle() + PI / 2

func explode():
	GameDialogueManager.camera_tremor(5.0)

	var explosion = preload("res://scenes/bullets/explosion.tscn").instantiate()
	get_parent().add_child(explosion)

	explosion.get_node("Explosion").setup(
		global_position,
		damage,
		tower_type,
		tower_id
	)

	queue_free()
