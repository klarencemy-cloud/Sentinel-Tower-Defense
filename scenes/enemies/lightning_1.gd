extends Line2D

var timer: float = 0.0
@onready var mat = ShaderMaterial

func _ready() -> void:
	material = material.duplicate()
	mat = material as ShaderMaterial
func _process(delta: float) -> void:
	timer += delta + .08

	if timer >= 1.0:
		timer = 0.0
		var array_thickness: Array = [.3, .4, .5, .6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		var thickness = randi_range(0, 16)
		mat.set_shader_parameter("Vanishing_Value", array_thickness[thickness])
		position = Vector2(
			randf_range(-10, 10),
			randf_range(-60, 60)
		)
		rotation = randf_range(-6.28, 6.28)
