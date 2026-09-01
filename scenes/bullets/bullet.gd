extends Area2D
@onready var mat = ShaderMaterial
var direction: Vector2
var speed: int = 1000
var damage: int = 1
var tower_id: int = -1
var lifetime: float = 5.0 # lifetime of bullets in seconds
var bounce_count: int = 0
var max_bounce: int = 1
var owner_tower_type
var bullet_enum: Data.Bullet
var ricochet_range: int = 0
var hit_enemies: Array = [] # Track which enemies have been hit by this ricochet chain
var already_hit: bool = false
var target: Area2D = null
var homingspeed = 6

var boss_types: Array = [
	Data.Enemy.BOSS1,
	Data.Enemy.BOSS2,
	Data.Enemy.BOSS3,
	Data.Enemy.BOSS4,
	Data.Enemy.BOSS5
]


func _ready():
	$Sprite2D.material = $Sprite2D.material.duplicate()
	mat = material as ShaderMaterial
	add_to_group("bullet")
	monitoring = true
	monitorable = true

	area_entered.connect(_on_area_entered)

func setup(pos, angle, _bullet_enum, _damage, _tower_type, _tower_id, _target = null):
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle

	damage = _damage
	bullet_enum = _bullet_enum
	owner_tower_type = _tower_type
	tower_id = _tower_id
	target = _target

	var tower_data = Data.TOWER_DATA.get(owner_tower_type, {})
	if tower_data.has("range"):
		ricochet_range = int(tower_data["range"])

	if owner_tower_type == Data.Tower.SPAM_FILTER and tower_data.get("tier1abilityunlocked", false):
		max_bounce = 2

	# BULLETS PER TOWER
	match owner_tower_type:
		Data.Tower.SPAM_FILTER:
			$Sprite2D.texture = load("res://graphics/bullets/spam_filter_bullet.png")
		Data.Tower.ANTIVIRUS:
			$Sprite2D.texture = load("res://graphics/bullets/anti_virus_bullet.png")
		Data.Tower.SANDBOX_ANALYZER:
			$Sprite2D.texture = load("res://graphics/bullets/sandbox_bullet.png")
		Data.Tower.DATA_LOSS_PREVENTION:
			$Sprite2D.texture = load("res://graphics/bullets/dlp_bullet.png")
		_:
			$Sprite2D.texture = load("res://graphics/bullets/default.png")
	z_index = -1


func _process(delta: float) -> void:
	if is_instance_valid(target):
		var desired = (target.global_position - global_position).normalized()
		direction = direction.lerp(desired, homingspeed * delta).normalized() 
		rotation = direction.angle()
		rotation = direction.angle() - PI / 2

	position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if already_hit:
		return

	if !area.is_in_group("Enemies"):
		return

	already_hit = true
	area.hit(damage, tower_id)
	hit_enemies.append(area) # Track this enemy as hit

	# sandbox analyzer traps enemy
	if owner_tower_type == Data.Tower.SANDBOX_ANALYZER:
		var tower = _get_owner_tower()
		if tower != null:
			tower.on_bullet_hit_enemy(area)

	if _can_ricochet(): # Spam Filter
		ricochet(area)
	else:
		queue_free()

	if owner_tower_type == Data.Tower.DATA_LOSS_PREVENTION:
		var tower = _get_owner_tower()
		if tower != null and tower.has_method("on_bullet_hit_enemy"):
			tower.on_bullet_hit_enemy(area)

	if Data.TOWER_DATA[Data.Tower.DATA_LOSS_PREVENTION].get("tier3abilityunlocked", false):
		if area.health > 0 and area.dlp_damage_reduction < 1.0:
			var max_hp = area.get_node("hpbar").max_value
			if area.health <= max_hp * 0.2:
				if randf() < 0.3:
					area.hit(area.health, tower_id)

func _get_owner_tower() -> Node:
	var towers = get_tree().get_nodes_in_group("Towers")
	for t in towers:
		if t.tower_id == tower_id:
			return t
	return null


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

		if e.fog_hidden:
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
	new_bullet.hit_enemies = hit_enemies.duplicate() # Pass the hit list to the new bullet

	new_bullet.tower_id = tower_id


	get_parent().add_child(new_bullet)
	queue_free()
