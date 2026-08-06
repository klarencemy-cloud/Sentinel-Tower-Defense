extends Tower

var ad_purge_timer: Timer
var malware_analyst_damage_buff: float = 0.0
var malware_analyst_crit_buff: int = 0

func _ready() -> void:
	super._ready()
	ad_purge_timer = Timer.new()
	ad_purge_timer.one_shot = false
	ad_purge_timer.autostart = true
	add_child(ad_purge_timer)
	ad_purge_timer.timeout.connect(_on_ad_purge_timer_timeout)
	_update_ad_purge_interval()

func _update_ad_purge_interval() -> void:
	var tower_data = Data.TOWER_DATA.get(type, {})
	if tower_data.get('tier3abilityunlocked', false):
		ad_purge_timer.wait_time = 1.0
	elif tower_data.get('tier1abilityunlocked', false):
		ad_purge_timer.wait_time = 2.0
	else:
		ad_purge_timer.wait_time = 3.0

func _process(_delta: float) -> void:
	_update_ad_purge_interval()
	# Apply passive auras to enemies in range
	var tower_data = Data.TOWER_DATA.get(type, null)
	if not tower_data:
		return
	
	var tier2_unlocked = tower_data.get('tier2abilityunlocked', false)


	if tier2_unlocked and ad_active:
		remove_ad()
	
func show_ad() -> void:
	var tower_data = Data.TOWER_DATA.get(type, {})
	if tower_data.get('tier2abilityunlocked', false):
		return
	
	if ad_active or ransomware_active:
		return

	ad_button.texture_normal = ads.pick_random()
	ad_button.scale = Vector2(3.5, 3.5)
	ad_button.visible = true
	ad_active = true
	disabled_by_ad = true

func _on_ad_purge_timer_timeout() -> void:
	if disabled_by_ad or disabled_by_ransomware:
		return

	for tower in get_tree().get_nodes_in_group("Towers"):
		if tower == self:
			continue
		if tower.global_position.distance_to(global_position) <= range:
			if tower.ad_active:
				tower.remove_ad()

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


func tower_upgrade():
	$Base.texture = load("res://graphics/towers/blaster/blaster upgrade.png")


func _on_pay_button_pressed() -> void:
	if Data.money < 5:
		return

	Data.money -= 5
	remove_ransomware()


func toggle_damage_buff(state: bool) -> void:
	$Particles/DamageBuff.visible = state