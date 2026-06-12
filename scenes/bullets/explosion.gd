extends Sprite2D

var damage: int = 1

func setup(pos: Vector2, new_damage: int):
	position = pos
	damage = new_damage
	$AnimationPlayer.play("explosion")


func hit_enemies():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if position.distance_to(enemy.global_position) < 30:
			enemy.hit(damage)