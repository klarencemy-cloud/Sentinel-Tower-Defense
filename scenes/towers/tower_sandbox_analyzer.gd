extends Tower
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0
var trapped_enemy: Node = null
var is_trapping: bool = false

var infected_enemies: Array = []
var max_infected: int = 2
const TIER1_MAX_INFECTED: int = 2
const TIER3_MAX_INFECTED: int = 5
var infection_check_timer: Timer
var infection_radius: float = 200.0

const TIER2_DEBUFF_MULTIPLIER: float = 1.2

var boss_types: Array = [
	Data.Enemy.BOSS1,
	Data.Enemy.BOSS2,
	Data.Enemy.BOSS3,
	Data.Enemy.BOSS4,
	Data.Enemy.BOSS5
]


func _ready() -> void:
	super._ready()
	
	# Infection Timer
	infection_check_timer = Timer.new()
	infection_check_timer.one_shot = false
	infection_check_timer.wait_time = 0.5
	infection_check_timer.timeout.connect(_check_infection_spread)
	add_child(infection_check_timer)


func _process(_delta: float) -> void:
	if not is_trapping:
		var target = _get_valid_target()
		if target != null:
			$Turret.look_at(target.global_position)
			$Turret.rotation -= PI / 2


func _get_valid_target() -> Node:
	# Filter out bosses from enemies list
	for enemy in enemies:
		if enemy != null and is_instance_valid(enemy):
			if not _is_boss(enemy):
				return enemy
	return null


func _is_boss(enemy: Node) -> bool:
	if enemy == null or not is_instance_valid(enemy):
		return false
	return enemy.enemy_type_stats in boss_types


func _tier1_unlocked() -> bool:
	var tower_data = Data.TOWER_DATA.get(type, {})
	return tower_data.get("tier1abilityunlocked", false)


func _tier2_unlocked() -> bool:
	var tower_data = Data.TOWER_DATA.get(type, {})
	return tower_data.get("tier2abilityunlocked", false)


func _tier3_unlocked() -> bool:
	var tower_data = Data.TOWER_DATA.get(type, {})
	return tower_data.get("tier3abilityunlocked", false)


func _get_max_infected() -> int:
	if _tier3_unlocked():
		return TIER3_MAX_INFECTED
	return TIER1_MAX_INFECTED


func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return
	if is_trapping:
		return

	var target = _get_valid_target()
	if target != null:
		var fire_rotation = $Turret.rotation

		if botnet_count > 0:
			fire_rotation += deg_to_rad(randf_range(-20.0, 20.0))

		var dir = Vector2.DOWN.rotated(fire_rotation).normalized()

		var base_damage = damage + (damage * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
		shoot.emit(
			position + dir * 16,
			fire_rotation,
			bullet_type,
			final_damage,
			type,
			tower_id,
			enemies[0]
		)

		$ShootSound.play()


func on_bullet_hit_enemy(enemy: Node) -> void:
	if _is_boss(enemy):
		return
	
	if not is_trapping and enemy != null and is_instance_valid(enemy):
		trap_enemy(enemy)


func trap_enemy(enemy: Node) -> void:
	trapped_enemy = enemy
	is_trapping = true
	infected_enemies.clear()
	
	if _tier2_unlocked():
		_apply_debuff(enemy)

	enemy.trap(self)

	if _tier1_unlocked():
		infection_check_timer.start()
		_check_infection_spread()
	
	# Upon enemies death, tower will be freed to fire again
	if not enemy.is_connected("tree_exited", _on_trapped_enemy_died):
		enemy.tree_exited.connect(_on_trapped_enemy_died)


func _apply_debuff(enemy: Node) -> void:
	# Apply debuff to enemy 20% dmg taken
	if enemy != null and is_instance_valid(enemy):
		enemy.vulnerability_multiplier *= TIER2_DEBUFF_MULTIPLIER


func _remove_debuff(enemy: Node) -> void:
	if enemy != null and is_instance_valid(enemy):
		enemy.vulnerability_multiplier /= TIER2_DEBUFF_MULTIPLIER


func _check_infection_spread() -> void:
	if not _tier1_unlocked():
		return
	
	if trapped_enemy == null or not is_instance_valid(trapped_enemy):
		return
	
	var current_max = _get_max_infected()
	if infected_enemies.size() >= current_max:
		return
	
	var all_enemies = get_tree().get_nodes_in_group("Enemies")
	
	for e in all_enemies:
		if e == trapped_enemy:
			continue
		
		if e in infected_enemies:
			continue
		
		if e.is_trapped:
			continue
		
		# Don't infect bosses
		if _is_boss(e):
			continue
		
		var dist = trapped_enemy.global_position.distance_to(e.global_position)
		if dist <= infection_radius:
			e.infect_trap(self)

			if _tier2_unlocked():
				_apply_debuff(e)
			
			infected_enemies.append(e)
			
			if not e.is_connected("tree_exited", _on_infected_enemy_died):
				e.tree_exited.connect(_on_infected_enemy_died.bind(e))
			
			if infected_enemies.size() >= current_max: # Check for max infection cap
				break


func _on_infected_enemy_died(enemy: Node) -> void:
	if enemy in infected_enemies:
		if _tier2_unlocked(): # Removes debuffs before removing enemy
			_remove_debuff(enemy)
		infected_enemies.erase(enemy)
		
		# If an infected enemy died, it will check for nearby enemies to infect again
		if _tier3_unlocked() or _tier1_unlocked():
			_check_infection_spread()


func _on_trapped_enemy_died() -> void:
	infection_check_timer.stop()
	
	if _tier1_unlocked():
		for infected in infected_enemies.duplicate():
			if infected != null and is_instance_valid(infected):
				if infected.is_connected("tree_exited", _on_infected_enemy_died):
					infected.disconnect("tree_exited", _on_infected_enemy_died)
				if _tier2_unlocked():
					_remove_debuff(infected)
				infected.release_from_infect_trap()
		
		infected_enemies.clear()
	
	# Release trapped enemies
	if trapped_enemy != null and is_instance_valid(trapped_enemy):
		if trapped_enemy.is_connected("tree_exited", _on_trapped_enemy_died):
			trapped_enemy.disconnect("tree_exited", _on_trapped_enemy_died)
		if _tier2_unlocked():
			_remove_debuff(trapped_enemy)
		trapped_enemy.release_from_trap()
	
	trapped_enemy = null
	is_trapping = false
	
	var target = _get_valid_target()
	if target != null:
		$Turret.look_at(target.global_position)
		$Turret.rotation -= PI / 2


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state