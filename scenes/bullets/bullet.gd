extends Area2D

var direction: Vector2
var speed: int = 200
var damage: int = 1
var bounce_count: int = 0
var max_bounce: int = 1
var owner_tower_type

func setup(pos, angle, _bullet_enum, _damage, _tower_type):
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle
	damage = _damage
	owner_tower_type = _tower_type

func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("enemies"):
		return

	body.take_damage(damage)

	if _can_ricochet():
		ricochet(body)
	else:
		queue_free()
		
func _can_ricochet() -> bool:
	if owner_tower_type == null:
		return false

	var data = Data.TOWER_DATA[owner_tower_type]

	if data.get("passive", "") != "Ricochet":
		return false
	return bounce_count < max_bounce
	
func ricochet(from_enemy: Node) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")

	var nearest = null
	var nearest_dist = 100

	for e in enemies:
		if e == from_enemy:
			continue

		var d = global_position.distance_to(e.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = e

	if nearest == null:
		queue_free()
		return

	var new_bullet = duplicate()

	new_bullet.damage = int(damage * 0.5)
	new_bullet.direction = (nearest.global_position - global_position).normalized()
	new_bullet.position = global_position

	new_bullet.owner_tower_type = owner_tower_type
	new_bullet.bounce_count = bounce_count + 1
	new_bullet.max_bounce = max_bounce

	get_parent().add_child(new_bullet)
