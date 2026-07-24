extends Area2D

@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D
var default_width: float
var default_sprite_scale_x: float

func _ready():
	var shape := collision.shape as RectangleShape2D
	default_width = shape.size.x
	default_sprite_scale_x = sprite.scale.x
	
func update_laser(start_pos: Vector2, end_pos: Vector2):
	global_position = start_pos
	look_at(end_pos)
	rotation -= PI / 2
	var distance = start_pos.distance_to(end_pos)
	$GPUParticles2D6.global_position = end_pos
	$GPUParticles2D6.emitting = true
	$GPUParticles2D5.emitting = true
	# Stretch sprite
	sprite.scale.y = distance / sprite.texture.get_height()
	
	# Move sprite so its base stays on the tower
	sprite.position.y = distance / 2

	# Stretch collision
	var shape := collision.shape as RectangleShape2D
	shape.size.y = distance
	var width := default_width

	if Data.TOWER_DATA[Data.Tower.AI_SECURITY].get("tier1abilityunlocked", false):
		width *= 1.25

	shape.size.x = width
	sprite.scale.x = default_sprite_scale_x * (width / default_width)

	collision.position.y = distance / 2


func damage_enemies(damage, tower_id):
	for enemy in get_overlapping_areas():
		if enemy.is_in_group("Enemies"):
			enemy.hit(damage, tower_id)

func hide_particles():
	$GPUParticles2D5.restart()
	$GPUParticles2D5.emitting = false
	$GPUParticles2D6.restart()
	$GPUParticles2D6.emitting = false
