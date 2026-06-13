class_name Tower extends Node2D

var enemies: Array
var type: Data.Tower
var upgraded: bool
var bullet_type: Data.Bullet
var cost: int
var upgrade_cost: int
var cell_pos: Vector2i = Vector2i.ZERO
@warning_ignore("unused_signal")
signal shoot(pos: Vector2, direction: float, bullet_enum: Data.Bullet, damage: int)
signal select(tower: Tower)
signal removed(cell_pos: Vector2i)

var range_indicator: Line2D

func _ready() -> void:
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
	$ReloadTimer.wait_time = Data.TOWER_DATA[tower_type]['reload_time']
	$TowerMenu.cost = Data.TOWER_DATA[tower_type]['upgrade_cost']
	bullet_type = Data.TOWER_DATA[tower_type]['bullet']
	cost = Data.TOWER_DATA[tower_type]['cost']
	upgrade_cost = Data.TOWER_DATA[tower_type]['upgrade_cost']
	type = tower_type

	var range_value = Data.TOWER_DATA[tower_type]['range']
	var shape = $EnemyDetectionArea/CollisionShape2D.shape
	if shape is CircleShape2D:
		shape.radius = range_value

	create_range_indicator()
	_update_range_indicator()


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
			$TowerMenu.reveal(upgraded)
			show_range()


func _on_tower_menu_upgrade_press() -> void:
	var u_cost = Data.TOWER_DATA[type]['upgrade_cost']
	if not Data.is_unli_money and Data.money < u_cost:
		return

	if not Data.is_unli_money:
		Data.money -= u_cost

	tower_upgrade()
	$TowerMenu.hide()
	upgraded = true
	hide_range()


func tower_upgrade():
	pass


func _on_tower_menu_delete_press() -> void:
	var return_money = cost if not upgraded else cost + upgrade_cost
	Data.money += return_money
	emit_signal('removed', cell_pos)
	queue_free()


func hide_ui():
	$TowerMenu.hide()
	hide_range()
