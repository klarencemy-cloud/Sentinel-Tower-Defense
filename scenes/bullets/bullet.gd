extends Area2D

var direction: Vector2
var speed: int = 600
var damage: int = 1
var tower_id: int = -1

var bounce_count: int = 0
var max_bounce: int = 1
var owner_tower_type
var bullet_enum: Data.Bullet
var ricochet_range: int = 0
var hit_enemies: Array = []  # Track which enemies have been hit by this ricochet chain
var already_hit := false
func _ready():
	add_to_group("bullet")
	monitoring = true
	monitorable = true

	area_entered.connect(_on_area_entered)


func setup(pos, angle, _bullet_enum, _damage, _tower_type, _tower_id):
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle

	damage = _damage
	bullet_enum = _bullet_enum
	owner_tower_type = _tower_type
	tower_id = _tower_id

	var tower_data = Data.TOWER_DATA.get(owner_tower_type, {})
	if tower_data.has("range"):
		ricochet_range = int(tower_data["range"])

	if owner_tower_type == Data.Tower.SPAM_FILTER and tower_data.get("tier1abilityunlocked", false):
		max_bounce = 2


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if already_hit:
		return
		
	if !area.is_in_group("Enemies"):
		return

	already_hit = true
	area.hit(damage, tower_id)
	hit_enemies.append(area)  # Track this enemy as hit

	if _can_ricochet():
		ricochet(area)
	else:
		queue_free()


func _can_ricochet() -> bool:
	var data = Data.TOWER_DATA.get(owner_tower_type, {})

	if data.get("passive", "") != "Ricochet":
		return false

	if bounce_count < max_bounce:
		return true

	if owner_tower_type == Data.Tower.SPAM_FILTER and data.get("tier3abilityunlocked", false) and bounce_count >= 2:
		return randf() < 0.5

	return false


func ricochet(from_enemy: Node) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var nearest_dist = INF

	for e in enemies:
		if e == from_enemy:
			continue
		
		# Skip enemies already hit by this ricochet chain
		if e in hit_enemies:
			continue

		var dist = from_enemy.global_position.distance_to(e.global_position)

		if dist > ricochet_range:
			continue

		if dist < nearest_dist:
			nearest_dist = dist
			nearest = e

	if nearest == null:
		queue_free()
		return

	print("RICOCHET -> ", nearest.name)

	var new_bullet = preload("res://scenes/bullets/bullet.tscn").instantiate()

	var dir = (nearest.global_position - from_enemy.global_position).normalized()

	new_bullet.global_position = from_enemy.global_position + dir * 10
	new_bullet.direction = dir
	new_bullet.rotation = dir.angle()

	var ricochet_damage_factor = 0.5
	var tower_data = Data.TOWER_DATA.get(owner_tower_type, {})
	if owner_tower_type == Data.Tower.SPAM_FILTER and tower_data.get("tier2abilityunlocked", false):
		ricochet_damage_factor = 0.75

	new_bullet.damage = int(damage * ricochet_damage_factor)

	new_bullet.bullet_enum = bullet_enum
	new_bullet.owner_tower_type = owner_tower_type
	new_bullet.bounce_count = bounce_count + 1
	new_bullet.max_bounce = max_bounce
	new_bullet.ricochet_range = ricochet_range
	new_bullet.hit_enemies = hit_enemies.duplicate()  # Pass the hit list to the new bullet

	new_bullet.tower_id = tower_id


	get_parent().add_child(new_bullet)
	queue_free()
