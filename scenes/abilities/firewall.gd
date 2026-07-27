extends Node2D

@onready var area_2d = $Area2D
@onready var hpbar = $hpbar
@onready var sprite = $Sprite2D
var health: float
var max_health: float
var firewall_tween: Tween

var attacking_enemies: Dictionary = {} # {enemy_instance: Timer}
var blocked_enemies: Array[Area2D] = []


func _ready() -> void:
	health = Data.ABILITY_DATA[Data.Ability.FIREWALL]['health']
	max_health = health
	
	hpbar.max_value = max_health
	hpbar.value = health
	
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)


func _physics_process(_delta: float) -> void:
	# Check if firewall is destroyed
	if health <= 0:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	# Check if it's an enemy (enemies extend Area2D)
	if area.is_in_group("Enemies"):
		if area.enemy_type_stats == Data.Enemy.SQL:
			return
		# Block enemy from moving
		if not blocked_enemies.has(area):
			blocked_enemies.append(area)
			area.blocked_by_firewall = true
		
		if not attacking_enemies.has(area):
			# Start attacking by enemy enemy
			var attack_interval = 1.0 / Data.ENEMY_DATA[area.enemy_type_stats]['atkspd']
			var timer = Timer.new()
			timer.wait_time = attack_interval
			timer.one_shot = false
			add_child(timer)
			timer.timeout.connect(_on_enemy_attack.bindv([area]))
			timer.start()
			attacking_enemies[area] = timer


func _on_area_exited(area: Area2D) -> void:
	# Check if it's an enemy leaving
	if area.is_in_group("Enemies"):
		if area.enemy_type_stats == Data.Enemy.SQL:
			return
		# Unblock enemy
		if blocked_enemies.has(area):
			blocked_enemies.erase(area)
			area.blocked_by_firewall = false
		
		if attacking_enemies.has(area):
			var timer = attacking_enemies[area]
			timer.queue_free()
			attacking_enemies.erase(area)


func _on_enemy_attack(enemy: Area2D) -> void:
	# Check if enemy still exists
	if not is_instance_valid(enemy):
		if attacking_enemies.has(enemy):
			attacking_enemies[enemy].queue_free()
			attacking_enemies.erase(enemy)
		return
	
	# Don't attack if enemy is frozen
	if enemy.is_frozen:
		return
	
	# Deal damage
	var damage = Data.ENEMY_DATA[enemy.enemy_type_stats]['damage']
	take_damage(damage)


func take_damage(damage: int) -> void:
	health -= damage
	hpbar.value = health
	flash()
	print("Firewall hit! Health: ", health, "/", max_health)
	
	if health <= 0:
		print("Firewall destroyed!")
		queue_free()

func flash() -> void:
	if firewall_tween and firewall_tween.is_valid():
		firewall_tween.kill()

	firewall_tween = create_tween()
	firewall_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.3), 0.1)
	firewall_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.15)
