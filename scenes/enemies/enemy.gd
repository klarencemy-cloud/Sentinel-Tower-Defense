extends Area2D

var path_follow: PathFollow2D
var health: int
var speed: int

var is_worm: bool = false

func _ready() -> void:
	add_to_group('Enemies')

func setup(new_path_follow: PathFollow2D, type: Data.Enemy):
	path_follow = new_path_follow
	health = Data.ENEMY_DATA[type]['health']
	speed = Data.ENEMY_DATA[type]['speed']
	# $Sprite2D.texture = load(Data.ENEMY_DATA[type]['texture'])

	match Data.ENEMY_DATA[type]['name']:
		"spam":
			$Spam.visible = true
		"adware":
			$Adware.visible = true
		"spyware":
			$Spyware.visible = true
	position += Vector2(randi_range(-4, 4), randi_range(-4, 4))


func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 0.99:
		Data.health -= 20
		queue_free()


func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit(bullet.damage)


func hit(damage: int = 1):
	health -= damage
	$AudioStreamPlayer2D.play()
	flash()

	if health <= 0:
		Data.money += 10
		queue_free()

func flash():
	var tween = create_tween()

	tween.tween_property($Adware.material, 'shader_parameter/Progress', 1.0, 0.2)
	tween.tween_property($Adware.material, 'shader_parameter/Progress', 0.0, 0.2)
