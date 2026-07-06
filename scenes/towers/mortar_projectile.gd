extends Area2D

var target_position: Vector2
var damage: int
var tower_type
var tower_id
var speed := 350

func setup(start_pos, target_pos, new_damage, _tower_type, _tower_id):
	global_position = start_pos
	target_position = target_pos
	damage = new_damage
	tower_type = _tower_type
	tower_id = _tower_id

func _process(delta):
	global_position = global_position.move_toward(target_position, speed * delta)
	rotation = (target_position - global_position).angle() + PI / 2
	if global_position.distance_to(target_position) < 8:
		explode()

func explode():
	var explosion = preload("res://scenes/bullets/explosion.tscn").instantiate()

	get_parent().add_child(explosion)

	explosion.get_node("Explosion").setup(
		global_position,
		damage,
		tower_type,
		tower_id
	)

	queue_free()
