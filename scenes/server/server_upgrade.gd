extends CanvasLayer

@onready var server_pts: Label = $UIContainer/ServerUpdate/ServerPoints/Label
@onready var offense_container: Control = $UIContainer/ServerUpdate/OffenseContainer
@onready var defense_container: Control = $UIContainer/ServerUpdate/DefenseContainer
@onready var economy_container: Control = $UIContainer/ServerUpdate/EconomyContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offense_container.refresh_pts.connect(_refresh_server_pts)
	defense_container.refresh_pts.connect(_refresh_server_pts)
	economy_container.refresh_pts.connect(_refresh_server_pts)
	_refresh_server_pts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _refresh_server_pts() -> void:
	server_pts.text = str(Data.server_points)

func _on_back_btn_pressed() -> void:
	get_tree().paused = false
	Data.toggle_server_scene.emit()

# Uprade category toglles
func _on_cyber_btn_pressed() -> void:
	$UIContainer/ServerBtn.add_theme_color_override("font_color", Color(0.176, 0.337, 0.451))
	$UIContainer/CyberBtn.add_theme_color_override("font_color", Color(0.827, 0.2, 0.2))
	$UIContainer/ServerBtn.add_theme_font_size_override("font_size", 30)
	$UIContainer/CyberBtn.add_theme_font_size_override("font_size", 40)
	$UIContainer/ServerUpdate.visible = false
	$UIContainer/CyberthreatUpdate.visible = true

func _on_server_btn_pressed() -> void:
	$UIContainer/ServerBtn.add_theme_color_override("font_color", Color(0.314, 0.655, 0.871))
	$UIContainer/CyberBtn.add_theme_color_override("font_color", Color(0.361, 0.161, 0.192))
	$UIContainer/ServerBtn.add_theme_font_size_override("font_size", 40)
	$UIContainer/CyberBtn.add_theme_font_size_override("font_size", 30)
	$UIContainer/ServerUpdate.visible = true
	$UIContainer/CyberthreatUpdate.visible = false


func _on_offense_pressed() -> void:
	$UIContainer/ServerUpdate/Offense.texture_normal = load("res://graphics/buttons/active_parallelogram.png")
	$UIContainer/ServerUpdate/Defense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/ServerUpdate/Economy.texture_normal = load("res://graphics/buttons/trapezoid_right.png")
	$UIContainer/ServerUpdate/OffenseContainer.visible = true
	$UIContainer/ServerUpdate/DefenseContainer.visible = false
	$UIContainer/ServerUpdate/EconomyContainer.visible = false


func _on_defense_pressed() -> void:
	$UIContainer/ServerUpdate/Offense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/ServerUpdate/Defense.texture_normal = load("res://graphics/buttons/active_parallelogram.png")
	$UIContainer/ServerUpdate/Economy.texture_normal = load("res://graphics/buttons/trapezoid_right.png")
	$UIContainer/ServerUpdate/OffenseContainer.visible = false
	$UIContainer/ServerUpdate/DefenseContainer.visible = true
	$UIContainer/ServerUpdate/EconomyContainer.visible = false


func _on_economy_pressed() -> void:
	$UIContainer/ServerUpdate/Offense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/ServerUpdate/Defense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/ServerUpdate/Economy.texture_normal = load("res://graphics/buttons/active_trapezoid_right.png")
	$UIContainer/ServerUpdate/OffenseContainer.visible = false
	$UIContainer/ServerUpdate/DefenseContainer.visible = false
	$UIContainer/ServerUpdate/EconomyContainer.visible = true
