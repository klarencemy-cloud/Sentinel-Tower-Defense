extends CanvasLayer
@onready var objectives_ui: CanvasLayer = $'.'

func _ready() -> void:
	objectives_ui.hide()

# func _process(delta: float) -> void:
# 	if GameDialogueManager.is_wave3_defeated and not GameDialogueManager.is_prep:
# 		$ObjectivesUi.show()
# 	else:
# 		$ObjectivesUi.hide()
