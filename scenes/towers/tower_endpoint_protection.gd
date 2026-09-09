extends Tower

var debuff_clear_timer: Timer
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0

func _ready() -> void:
	super._ready()
	debuff_clear_timer = Timer.new()
	debuff_clear_timer.autostart = true
	debuff_clear_timer.timeout.connect(_clear_nearby_debuffs)
	add_child(debuff_clear_timer)
	_update_debuff_clear_interval()

func refresh_stats():
	super.refresh_stats()
	_update_debuff_clear_interval()

func _update_debuff_clear_interval() -> void:
	if not debuff_clear_timer:
		return
	var tower_data = Data.TOWER_DATA.get(type, {})
	debuff_clear_timer.wait_time = 1.0 if tower_data.get("tier2abilityunlocked", false) else 2.0


func _clear_nearby_debuffs() -> void:
	var tower_data = Data.TOWER_DATA.get(type, {})

	var clear_limit := 2

	if tower_data.get("tier3abilityunlocked", false):
		clear_limit = INF # Clear every tower
	elif tower_data.get("tier1abilityunlocked", false):
		clear_limit = 5

	var candidates := []

	for tower in get_tree().get_nodes_in_group("Towers"):
		if tower == self:
			continue
		if global_position.distance_to(tower.global_position) <= range:
			candidates.append(tower)

	candidates.shuffle()

	for tower in candidates:
		if clear_limit != INF and clear_limit <= 0:
			break

		tower.clear_debuffs_from_endpoint()

		if clear_limit != INF:
			clear_limit -= 1
	
func _on_reload_timer_timeout() -> void:
	if stunned:
		return
	if disabled_by_ad or disabled_by_ransomware:
		return
	# Get all visible enemies in range
	var valid_enemies = enemies.size()
	
	if valid_enemies > 0:
		var base_damage = Data.TOWER_DATA[type]["damage"] + (Data.TOWER_DATA[type]["damage"] * malware_analyst_damage_buff)
		var final_damage = Data.calculate_crit_damage(type, base_damage, malware_analyst_crit_buff)
		shoot.emit(position, 0, bullet_type, final_damage, type, tower_id)
		$ShootSound.play()
		fire_animation()

func fire_animation():
	for particles: GPUParticles2D in $Particles.get_children():
		particles.restart()
		particles.emitting = true

func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state

func toggle_swift_buff(state: bool) -> void:
	$Particles/SwiftBuff.visible = state
