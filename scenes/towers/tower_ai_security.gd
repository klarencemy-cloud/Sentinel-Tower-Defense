extends Tower

var target: Area2D = null
@onready var laser := $Laser
var damage_multiplier := 1.0
const MAX_DAMAGE_MULTIPLIER := 2.0

const LASER_EXTEND_TIME := 0.5
var laser_progress := 0.0
var laser_extending := false
var laser_ready := false

@onready var lightning := $Turret/Particles/Lightning
var mat: ShaderMaterial
var timer: float = 0.0

func _ready():
	mat = lightning.material.duplicate()
	lightning.material = mat
	super()

	laser.visible = false
	laser.monitoring = false
	$ReloadTimer.stop()
	
func _process(_delta):
	timer += _delta + .08
	if timer >= 1.0:
		timer = 0.0
		var array_thickness: Array = [.3, .4, .5, .6, .6, .6, .1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		var thickness = randi_range(0, 16)
		mat.set_shader_parameter("Vanishing_Value", array_thickness[thickness])
	
	if stunned or disabled_by_ad or disabled_by_ransomware:
		clear_target()
		return
	
	if target == null:
		acquire_target()

	if target == null:
		return

	if !is_instance_valid(target):
		clear_target()
		return
	
	if target.dead:
		clear_target()
		return
	
	if !(target in enemies):
		clear_target()
		return

	$Turret.look_at(target.global_position)
	$Turret.rotation -= PI / 2
	laser.visible = true
	laser.monitoring = true
	if laser_extending:
		laser_progress += _delta / LASER_EXTEND_TIME

		if laser_progress >= 1.0:
			laser_progress = 1.0
			laser_extending = false
			laser_ready = true

			$ReloadTimer.start()

	laser.update_laser(
		$Turret/LaserOrigin.global_position,
   	 	target.global_position,
		laser_progress
)

func acquire_target():
	for enemy in enemies:
		if is_instance_valid(enemy):
			target = enemy

			laser_progress = 0.0
			laser_extending = true
			laser_ready = false

			$ReloadTimer.stop()
			return

func clear_target():
	target = null
	damage_multiplier = 1.0
	laser.visible = false
	laser.monitoring = false
	laser.hide_particles()
	laser_progress = 0.0
	laser_extending = false
	laser_ready = false

	$ReloadTimer.stop()
	if laser.has_overlapping_areas():
		laser.monitoring = false
	
func _on_reload_timer_timeout() -> void:
	if !laser_ready:
		return
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return

	if target == null:
		return
	if !is_instance_valid(target):
		return

	var base_damage = Data.TOWER_DATA[type]["damage"]

	if Data.TOWER_DATA[type].get("tier3abilityunlocked", false):
		damage_multiplier = min(
			damage_multiplier + 0.1,
			MAX_DAMAGE_MULTIPLIER
		)

	base_damage = int(base_damage * damage_multiplier)

	var final_damage = Data.calculate_crit_damage(type, base_damage)
	var enemy_max_hp = Data.ENEMY_DATA[target.enemy_type_stats]["health"]

	if Data.TOWER_DATA[type].get("tier2abilityunlocked", false):
		if target.health <= enemy_max_hp * 0.10:
			target.hit(target.health, tower_id)
			return
	laser.damage_enemies(final_damage, tower_id)

	$ShootSound.play()


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()
