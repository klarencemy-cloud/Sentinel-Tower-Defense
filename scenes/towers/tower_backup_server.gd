extends Tower


var lightning: Array[Line2D]
var timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Line2D:
			lightning.append(child)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta + .03
	if timer >= 1.0:
		timer = 0.0
		for light in lightning:
			light.hide()
		lightning[randi_range(0, 8)].show()
		lightning[randi_range(0, 8)].show()