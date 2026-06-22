extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_btn_pressed() -> void:
	pass

func _on_cyber_btn_pressed() -> void:
	$ServerBtn.add_theme_color_override("font_color", Color(0.176, 0.337, 0.451))
	$CyberBtn.add_theme_color_override("font_color", Color(0.827, 0.2, 0.2))
	$ServerBtn.add_theme_font_size_override("font_size", 30)
	$CyberBtn.add_theme_font_size_override("font_size", 40)
	$Server.visible = false
	$CyberthreatUpdateUi.visible = true

func _on_server_btn_pressed() -> void:
	$ServerBtn.add_theme_color_override("font_color", Color(0.314, 0.655, 0.871))
	$CyberBtn.add_theme_color_override("font_color", Color(0.361, 0.161, 0.192))
	$ServerBtn.add_theme_font_size_override("font_size", 40)
	$CyberBtn.add_theme_font_size_override("font_size", 30)
	$Server.visible = true
	$CyberthreatUpdateUi.visible = false
