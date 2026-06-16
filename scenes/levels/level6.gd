extends Node

@onready var path1: Node = $Path2D/PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	path1.progress_ratio += .009
