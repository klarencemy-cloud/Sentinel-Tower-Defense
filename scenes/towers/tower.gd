class_name Tower extends Node2D

var enemies: Array
var type: Data.Tower
var bullet_type: Data.Bullet
var cost: int
var currentserverload
var cell_pos: Vector2i = Vector2i.ZERO
var damage: int = 0
var reload_time: float = 0.0
var tower_id
var range: float = 0.0
var ad_active := false
var disabled_by_ad := false
var ransomware_active := false
var disabled_by_ransomware := false
var spyware_count := 0
var botnet_count := 0
var virus_count := 0
var original_reload_time := 0.0
@onready var ad_button = $AdButton
@onready var pay_button: TextureButton = $PayButton
@onready var ads = [
	preload("res://graphics/buttons/ad1.png"),
	preload("res://graphics/buttons/ad2.png")
]

@warning_ignore("unused_signal")
signal shoot(pos: Vector2, direction: float, bullet_enum: Data.Bullet, damage: int, tower_type: Data.Tower, tower_id: int)
signal shoot_mortar(start_pos: Vector2, target_pos: Vector2, damage: int, tower_type: Data.Tower, tower_id: int)
signal select(tower: Tower)
signal removed(cell_pos: Vector2i)

var range_indicator: Line2D


func _ready() -> void:
	add_to_group("towers")
	original_reload_time = reload_time
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
	currentserverload = Data.TOWER_DATA[tower_type]["server_load"]
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
	Data.currentserverload -= currentserverload
	emit_signal("removed", cell_pos)
	queue_free()
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.refresh_tower_cards()


func hide_ui():
	$TowerMenu.hide()
	hide_range()

func refresh_stats(): 
	var data = Data.TOWER_DATA[type]

	damage = data["damage"]
	reload_time = data["reload_time"] - (data["reload_time"] * Offense.multiplied_atk_speed) # Applies server upgrade reload time or atk speed not sure if working din
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

func apply_crit_to_damage(base_damage: int) -> int:
	var tower_data = Data.TOWER_DATA.get(type, {})
	var crit_chance = tower_data.get("crit rate", 0) / 100.0
	var crit_multiplier = tower_data.get("crit damage", 0) / 100.0
	var total_crit_chance = Offense.multiplied_crit_chance + crit_chance # Applies server upgrade crit
	if randf() < total_crit_chance:
		return int(base_damage * (1.0 + crit_multiplier))
	return base_damage

func show_ad():
	if ad_active or ransomware_active:
		return

	ad_button.texture_normal = ads.pick_random()
	ad_button.visible = true
	ad_active = true
	disabled_by_ad = true

func remove_ad():
	ad_active = false
	disabled_by_ad = false
	ad_button.visible = false

	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui._schedule_next_ad()

func _on_ad_button_pressed():
	remove_ad()

func ransomware_effect():
	if ransomware_active or ad_active:
		return

	ransomware_active = true
	disabled_by_ransomware = true
	pay_button.visible = true

func remove_ransomware():
	ransomware_active = false
	disabled_by_ransomware = false
	pay_button.visible = false

	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui._schedule_next_ransomware()
	
