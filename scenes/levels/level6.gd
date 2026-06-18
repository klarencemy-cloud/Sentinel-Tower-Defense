extends Node

@onready var path1: Node = $Path2D/PathFollow2D
@onready var sprite: Node = $Path2D/PathFollow2D/AnimatedSprite2D

var previous_pos: Vector2

func _ready() -> void:
	previous_pos = path1.global_position

func _process(delta: float) -> void:
	path1.progress_ratio += .0003

	var direction = path1.global_position - previous_pos
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	previous_pos = path1.global_position
