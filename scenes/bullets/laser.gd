extends Area2D

@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D
var default_width: float
var default_length: float
var default_sprite_scale_x: float
var default_sprite_scale_y: float

func _ready():
	var shape := collision.shape as RectangleShape2D

	default_width = shape.size.x
	default_length = shape.size.y

	default_sprite_scale_x = sprite.scale.x
	default_sprite_scale_y = sprite.scale.y
	
	
func update_laser(start_pos: Vector2, end_pos: Vector2, progress := 1.0):
	global_position = start_pos
	look_at(end_pos)
	rotation -= PI / 2

	var full_distance = start_pos.distance_to(end_pos)
	var distance = full_distance * progress
	var tip = start_pos.lerp(end_pos, progress)

	# Endpoint particle
	$GPUParticles2D6.global_position = tip

	if progress > 0.0:
		$GPUParticles2D6.emitting = true
		$GPUParticles2D5.emitting = true
	else:
		$GPUParticles2D6.emitting = false
		$GPUParticles2D5.emitting = false

	# Stretch laser to exact distance
	sprite.scale.y = default_sprite_scale_y * (distance / default_length)

	# Center the laser between start and endpoint
	sprite.position.y = distance / 2.0

	# Collision
	var shape := collision.shape as RectangleShape2D
	shape.size.y = distance

	var width := default_width

	if Data.TOWER_DATA[Data.Tower.AI_SECURITY].get("tier1abilityunlocked", false):
		width *= 5

	shape.size.x = width
	sprite.scale.x = default_sprite_scale_x * (width / default_width)

	collision.position.y = distance / 2.0


func damage_enemies(damage, tower_id):
	for enemy in get_overlapping_areas():
		if enemy.is_in_group("Enemies"):
			enemy.hit(damage, tower_id)

func hide_particles():
	$GPUParticles2D5.emitting = false
	$GPUParticles2D5.restart()

	$GPUParticles2D6.emitting = false
	$GPUParticles2D6.restart()
