extends Sprite2D

var damage: int = 1
var tower_id: int = -1
var explosionrange: float = 100
var tower_type = null

func setup(pos: Vector2, new_damage: int, _tower_type = null, _tower_id: int = -1):
	position = pos
	damage = new_damage
	tower_id = _tower_id
	tower_type = _tower_type

	if _tower_type != null:
		var td = Data.TOWER_DATA.get(_tower_type, null)
		if td:
			explosionrange = td.get("explosion_radius", explosionrange)
	$AnimationPlayer.play("explosion")


func hit_enemies():
	# Provide local access to the tower's data dictionary for debug/logic
	var tower_data = null
	var stun_duration = 1
	if tower_type != null:
		tower_data = Data.TOWER_DATA.get(tower_type, null)
		if tower_type == Data.Tower.QUARANTINE_CANNON and tower_data and tower_data.get('tier1abilityunlocked', false):
			stun_duration = 1.5
			print("tier1 unlocked")
		else:
			print("tier1 not unlocked")
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if global_position.distance_to(enemy.global_position) < explosionrange:
			# Skip invisible insider threat - should not be affected by explosions when invisible
			if enemy.enemy_type_stats == Data.Enemy.INSIDERTHREAT and enemy.invisible:
				continue
			
			if tower_type == Data.Tower.QUARANTINE_CANNON:
				var vulnerable = tower_data.get('tier3abilityunlocked', false)
				if tower_data.get('tier2abilityunlocked', false):
					enemy.stun_then_slow(stun_duration, 2.0, vulnerable)
				else:
					enemy.stun(stun_duration, vulnerable)
			enemy.hit(damage, tower_id)
		
