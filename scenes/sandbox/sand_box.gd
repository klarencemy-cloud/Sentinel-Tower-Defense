extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

	

func _exit_tree() -> void:
	Data.is_sandbox = false
	Data.money = 200
	Data.health = 100

	$Level/UI/Control/TextureRect/SandboxMenuContainer/MaxedLVL.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliMoney.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliHealth.button_pressed = false
	$Level/UI/Control/TextureRect/SandboxMenuContainer/UnliSentiCap.button_pressed = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
