extends Sprite2D

var damage: int = 1
var tower_id: int = -1

func setup(pos: Vector2, new_damage: int, _tower_id: int = -1):
	position = pos
	damage = new_damage
	tower_id = _tower_id
	$AnimationPlayer.play("explosion")


func hit_enemies():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if position.distance_to(enemy.global_position) < 100:
			enemy.stun(0.5)
			enemy.hit(damage, tower_id)
