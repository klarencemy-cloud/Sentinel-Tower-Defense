extends Area2D

var direction: Vector2
var speed: int = 200
var damage: int = 1
func setup(pos, angle, _bullet_enum, _damage):
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle
	damage = _damage

func _process(delta: float) -> void:
	position += direction * speed * delta
