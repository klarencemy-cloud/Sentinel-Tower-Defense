class_name Tower extends Node2D

var enemies: Array
var type: Data.Tower
var bullet_type: Data.Bullet
var cost: int
var cell_pos: Vector2i = Vector2i.ZERO
var damage := 0
var reload_time := 0.0
var range := 0.0


@warning_ignore("unused_signal")
signal shoot(pos: Vector2, direction: float, bullet_enum: Data.Bullet, damage: int)
signal select(tower: Tower)
signal removed(cell_pos: Vector2i)

var range_indicator: Line2D


func _ready() -> void:
	add_to_group("towers")
	create_range_indicator()


func create_range_indicator() -> void:
	if range_indicator:
		return

	range_indicator = Line2D.new()
	range_indicator.width = 2
	range_indicator.default_color = Color(1, 1, 1, 1)
	range_indicator.visible = false
	range_indicator.z_index = 100
	add_child(range_indicator)


func _update_range_indicator() -> void:
	if not range_indicator:
		return
	var shape = $EnemyDetectionArea/CollisionShape2D.shape
	var radius = 0.0

	if shape is CircleShape2D:
		radius = shape.radius

	var points = []
	var segments = 100

	for i in range(segments + 1):
		points.append(Vector2(cos(TAU * i / segments), sin(TAU * i / segments)) * radius)

	range_indicator.points = points


func show_range() -> void:
	create_range_indicator()
	_update_range_indicator()
	range_indicator.visible = true


func hide_range() -> void:
	if range_indicator:
		range_indicator.visible = false


func setup(tower_type: Data.Tower):
	type = tower_type

	bullet_type = Data.TOWER_DATA[tower_type]["bullet"]
	cost = Data.TOWER_DATA[tower_type]["cost"]

	refresh_stats()


func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies:
		enemies.append(area)


func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if area in enemies:
		enemies.erase(area)


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.button_mask == 1:
		if not $DelayTimer.time_left:
			select.emit(self)
			$TowerMenu.reveal()
			show_range()


func _on_tower_menu_delete_press() -> void:
	Data.money += cost
	emit_signal("removed", cell_pos)
	queue_free()


func hide_ui():
	$TowerMenu.hide()
	hide_range()

func refresh_stats():
	var data = Data.TOWER_DATA[type]

	damage = data["damage"]
	reload_time = data["reload_time"]
	range = data["range"]

	# reload timer update
	$ReloadTimer.wait_time = reload_time

	# range collision update
	var shape = $EnemyDetectionArea/CollisionShape2D.shape
	if shape is CircleShape2D:
		shape.radius = range

	# visual update
	_update_range_indicator()

	if range_indicator and range_indicator.visible:
		show_range()
