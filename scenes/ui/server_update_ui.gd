extends CanvasLayer


func _on_offense_pressed() -> void:
	$UIContainer/Offense.texture_normal = load("res://graphics/buttons/active_parallelogram.png")
	$UIContainer/Defense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/Economy.texture_normal = load("res://graphics/buttons/trapezoid_right.png")
	$UIContainer/OffenseContainer.visible = true
	$UIContainer/DefenseContainer.visible = false
	$UIContainer/EconomyContainer.visible = false


func _on_defense_pressed() -> void:
	$UIContainer/Offense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/Defense.texture_normal = load("res://graphics/buttons/active_parallelogram.png")
	$UIContainer/Economy.texture_normal = load("res://graphics/buttons/trapezoid_right.png")
	$UIContainer/OffenseContainer.visible = false
	$UIContainer/DefenseContainer.visible = true
	$UIContainer/EconomyContainer.visible = false

func _on_economy_pressed() -> void:
	$UIContainer/Offense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/Defense.texture_normal = load("res://graphics/buttons/parallelogram.png")
	$UIContainer/Economy.texture_normal = load("res://graphics/buttons/active_trapezoid_right.png")
	$UIContainer/OffenseContainer.visible = false
	$UIContainer/DefenseContainer.visible = false
	$UIContainer/EconomyContainer.visible = true
