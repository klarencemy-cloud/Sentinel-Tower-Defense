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
var spyware_sources: Dictionary = {}
var botnet_sources: Dictionary = {}
var virus_sources: Dictionary = {}
var virus_immunity_sources: Dictionary = {}
var spyware_immunity_sources: Dictionary = {}
var botnet_immunity_sources: Dictionary = {}
var original_reload_time := 0.0
var stunned := false
@onready var ad_button = $AdButton
@onready var pay_button: TextureButton = $PayButton
@onready var ads = [
	preload("res://graphics/buttons/ad1.png"),
	preload("res://graphics/buttons/ad2.png")
]

@warning_ignore("unused_signal")
signal shoot(pos: Vector2, direction: float, bullet_enum: Data.Bullet, damage: int, tower_type: Data.Tower, tower_id: int)
signal shoot_mortar(start_pos, target_enemy, damage, tower_type, tower_id)
signal removed(cell_pos: Vector2i)
signal select(tower: Tower)

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

	if not has_node("EnemyDetectionArea/CollisionShape2D"):
		return

	var shape = $EnemyDetectionArea/CollisionShape2D.shape
	var radius := 0.0

	if shape is CircleShape2D:
		radius = shape.radius

	var points = []
	var segments = 100

	for i in range(segments + 1):
		points.append(Vector2(cos(TAU * i / segments), sin(TAU * i / segments)) * radius)

	range_indicator.points = points

func show_range() -> void:
	if not has_node("EnemyDetectionArea/CollisionShape2D"):
		return

	create_range_indicator()
	_update_range_indicator()
	range_indicator.visible = true


func hide_range() -> void:
	if range_indicator:
		range_indicator.visible = false


func setup(tower_type: Data.Tower):
	type = tower_type

	var tower_data = Data.TOWER_DATA.get(tower_type, {})
	bullet_type = tower_data.get("bullet", Data.Bullet.SINGLE)
	cost = tower_data.get("cost", 0)
	currentserverload = tower_data.get("server_load", 0)
	refresh_stats()


func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if !("enemy_type_stats" in area):
		return

	if area not in enemies:
		enemies.append(area)

	if area.enemy_type_stats == Data.Enemy.TROJAN:
		area.hostile_count += 1
		area.speed = area.base_speed + 150


func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if !("enemy_type_stats" in area):
		return

	if area in enemies:
		enemies.erase(area)

	if area.enemy_type_stats == Data.Enemy.TROJAN:
		area.hostile_count = max(area.hostile_count - 1, 0)

		if area.hostile_count == 0:
			area.speed = area.base_speed

func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var delay_timer := get_node_or_null("DelayTimer")

		if delay_timer == null or delay_timer.time_left <= 0.0:
			select.emit(self)
			$TowerMenu.reveal()
			show_range()


func _on_tower_menu_delete_press() -> void:
	if type == Data.Tower.BACKUP_SERVER:
		Data.backup_server_placed = false
		
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
	var data = Data.TOWER_DATA.get(type, {})

	damage = data.get("damage", 0)
	range = data.get("range", 0.0)

	if data.has("reload_time"):
		var base_reload: float = float(data["reload_time"])
		reload_time = base_reload - (base_reload * Offense.multiplied_atk_speed)
		original_reload_time = reload_time

		if has_node("ReloadTimer"):
			$ReloadTimer.wait_time = reload_time

	if has_node("EnemyDetectionArea/CollisionShape2D"):
		var shape = $EnemyDetectionArea/CollisionShape2D.shape
		if shape is CircleShape2D:
			shape.radius = range

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
	ad_button.scale = Vector2(3.5, 3.5)
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

func clear_debuffs_from_endpoint() -> void:
	for source_id in spyware_sources:
		spyware_immunity_sources[source_id] = true

	spyware_sources.clear()
	spyware_count = 0
	var detection_shape := get_node_or_null("EnemyDetectionArea/CollisionShape2D")
	if detection_shape and detection_shape.shape is CircleShape2D:
		detection_shape.shape.radius = range

	for source_id in botnet_sources:
		botnet_immunity_sources[source_id] = true

	botnet_sources.clear()
	botnet_count = 0
	
	for source_id in virus_sources:
		virus_immunity_sources[source_id] = true
	virus_sources.clear()
	virus_count = 0
	reload_time = original_reload_time
	var reload_timer := get_node_or_null("ReloadTimer") as Timer
	if reload_timer:
		reload_timer.wait_time = reload_time

	if ad_active:
		remove_ad()
	if ransomware_active:
		remove_ransomware()
	

func apply_boss3_stun(duration: float):
	if stunned:
		return

	stunned = true
	modulate = Color.YELLOW

	await get_tree().create_timer(duration).timeout

	stunned = false
	modulate = Color.WHITE
