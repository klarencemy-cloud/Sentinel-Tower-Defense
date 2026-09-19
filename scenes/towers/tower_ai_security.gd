extends Tower
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0
@onready var charge_sound: AudioStreamPlayer2D = $ChargeSound
@onready var firing_sound: AudioStreamPlayer2D = $FiringSound

var target: Area2D = null
@onready var laser := $Laser
var damage_multiplier := 1.0
const MAX_DAMAGE_MULTIPLIER := 2.0

const LASER_SPEED: float = 600.0

var laser_extend_time: float = 1.0
var laser_progress := 0.0
var laser_extending := false
var laser_ready := false
var charge_sound_played := false
var firing_sound_playing := false

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
	charge_sound_played = false
	firing_sound_playing = false
	
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

	# Check if target is still within tower range
	var tower_range = Data.TOWER_DATA[type]["range"]
	var distance_to_target = global_position.distance_to(target.global_position)

	if distance_to_target > tower_range:
		clear_target()
		return

	$Turret.look_at(target.global_position)
	$Turret.rotation -= PI / 2
	laser.visible = true
	laser.monitoring = true

	# Play charge sound once at start
	if not charge_sound_played:
		charge_sound.play()
		charge_sound_played = true

	# Start firing sound once laser is fully extended and ready
	if laser_ready and not firing_sound_playing:
		firing_sound.play()
		firing_sound_playing = true

	if laser_extending:
		laser_progress += _delta / laser_extend_time

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
			charge_sound_played = false
			firing_sound_playing = false

			var distance = $Turret/LaserOrigin.global_position.distance_to(enemy.global_position)
			laser_extend_time = distance / LASER_SPEED
			if laser_extend_time < 0.05:
				laser_extend_time = 0.05

			$ReloadTimer.stop()
			return

func clear_target():
	target = null
	damage_multiplier = 1.0

	laser_progress = 0.0
	laser_extending = false
	laser_ready = false
	charge_sound_played = false

	if firing_sound_playing:
		firing_sound.stop()
		firing_sound_playing = false

	laser_extend_time = 1.0

	$ReloadTimer.stop()

	# Reset laser geometry to the tower
	var laser_origin = $Turret/LaserOrigin.global_position
	laser.update_laser(laser_origin, laser_origin, 0.0)

	# Stop and clear particles
	laser.hide_particles()

	# Hide and disable laser
	laser.visible = false
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

	var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)

	if Data.TOWER_DATA[type].get("tier3abilityunlocked", false):
		damage_multiplier = min(
			damage_multiplier + 0.1,
			MAX_DAMAGE_MULTIPLIER
		)

	base_damage = int(base_damage * damage_multiplier)

	var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
	var enemy_max_hp = Data.ENEMY_DATA[target.enemy_type_stats]["health"]

	if Data.TOWER_DATA[type].get("tier2abilityunlocked", false):
		if target.health <= enemy_max_hp * 0.10:
			target.hit(target.health, tower_id)
			return
	laser.damage_enemies(final_damage, tower_id)

	$ShootSound.play()


func _on_pay_button_pressed() -> void:
	var ransom_cost: int = currentserverload * 5
	if Data.money < ransom_cost:
		return

	Data.money -= ransom_cost
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
