extends VMWaveChallenge

const TOTAL_WAVES := 7

const FOG_ZONE_FRACTIONS: Array[float] = [0.35, 0.70]
const FOG_RADIUS := 160.0
const FOG_CHECK_INTERVAL := 0.1

const WAVES: Array[Dictionary] = [
	{
		"name": "Signal Noise",
		"composition": {Data.Enemy.SPAM: 14, Data.Enemy.VIRUS: 10, Data.Enemy.ADWARE: 8},
		"spawn_interval": 0.90,
		"hp_mult": 1.00,
	},
	{
		"name": "Dropped Frames",
		"composition": {Data.Enemy.VIRUS: 10, Data.Enemy.WORM: 12, Data.Enemy.ADWARE: 10, Data.Enemy.SPYWARE: 6},
		"spawn_interval": 0.85,
		"hp_mult": 1.05,
	},
	{
		"name": "Latency Spike",
		"composition": {Data.Enemy.WORM: 12, Data.Enemy.SPYWARE: 12, Data.Enemy.BOTNET: 8, Data.Enemy.CREDS: 8},
		"spawn_interval": 0.80,
		"hp_mult": 1.10,
	},
	{
		"name": "Route Flap",
		"composition": {Data.Enemy.BOTNET: 12, Data.Enemy.CREDS: 10, Data.Enemy.TROJAN: 10, Data.Enemy.SPYWARE: 8},
		"spawn_interval": 0.78,
		"hp_mult": 1.15,
	},
	{
		"name": "Blackout Window",
		"composition": {Data.Enemy.TROJAN: 12, Data.Enemy.INSIDERTHREAT: 8, Data.Enemy.BOTNET: 10, Data.Enemy.CREDS: 8},
		"spawn_interval": 0.75,
		"hp_mult": 1.35,
	},
	{
		"name": "Total Desync",
		"composition": {Data.Enemy.INSIDERTHREAT: 16, Data.Enemy.TROJAN: 12, Data.Enemy.SPYWARE: 10, Data.Enemy.BOTNET: 10},
		"spawn_interval": 0.72,
		"hp_mult": 1.45,
	},
	{
		"name": "WannaCry",
		"boss": Data.Enemy.BOSS3,
		"composition": {Data.Enemy.INSIDERTHREAT: 16, Data.Enemy.TROJAN: 14, Data.Enemy.BOTNET: 12, Data.Enemy.SPYWARE: 10},
		"spawn_interval": 0.70,
		"hp_mult": 1.50,
	},
]

var _fog_zones: Array[Vector2] = []
var _fog_shader_material: ShaderMaterial
var fog_check_timer: Timer


func _use_story_wave_position() -> bool:
	return true


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()
	_build_fog_zones()

	fog_check_timer = Timer.new()
	fog_check_timer.wait_time = FOG_CHECK_INTERVAL
	fog_check_timer.timeout.connect(_on_fog_check_tick)
	add_child(fog_check_timer)
	fog_check_timer.start()


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]


func _on_session_ended() -> void:
	super._on_session_ended()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.fog_hidden:
			enemy.set_fog_hidden(false)


func _build_fog_zones() -> void:
	_fog_zones.clear()
	if wave_manager == null:
		return

	var paths: Array = wave_manager._get_paths()
	for path in paths:
		if not (path is Path2D) or path.curve == null:
			continue
		var length: float = path.curve.get_baked_length()
		if length <= 0.0:
			continue
		for fraction in FOG_ZONE_FRACTIONS:
			var local_point: Vector2 = path.curve.sample_baked(length * fraction)
			var global_point: Vector2 = path.to_global(local_point)
			_fog_zones.append(global_point)
			_spawn_fog_visual(global_point)


func _spawn_fog_visual(zone_center: Vector2) -> void:
	if _fog_shader_material == null:
		_fog_shader_material = _build_fog_material()

	var visual := ColorRect.new()
	visual.size = Vector2(FOG_RADIUS * 2.0, FOG_RADIUS * 2.0)
	visual.position = zone_center - Vector2(FOG_RADIUS, FOG_RADIUS)
	visual.color = Color(0.49, 0.87, 0.78, 0.55)
	visual.material = _fog_shader_material
	visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visual.z_index = 5
	add_child(visual)


func _build_fog_material() -> ShaderMaterial:
	var noise := FastNoiseLite.new()
	noise.frequency = 0.012

	var noise_tex := NoiseTexture2D.new()
	noise_tex.width = 200
	noise_tex.height = 200
	noise_tex.seamless = true
	noise_tex.seamless_blend_skirt = 0.75
	noise_tex.noise = noise

	var mat := ShaderMaterial.new()
	mat.shader = preload("res://scenes/virtualmachinemode/maps/vm_map_5_fog.gdshader")
	mat.set_shader_parameter("noise_texture", noise_tex)
	mat.set_shader_parameter("speed", Vector2(0.02, 0.01))
	mat.set_shader_parameter("density_low", 0.22)
	mat.set_shader_parameter("density_high", 0.68)
	mat.set_shader_parameter("edge_softness", 0.62)
	mat.set_shader_parameter("edge_warp", 0.35)
	return mat


func _on_fog_check_tick() -> void:
	if not session_active:
		return
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var inside := _is_in_any_fog(enemy.global_position)
		if inside != enemy.fog_hidden:
			enemy.set_fog_hidden(inside)


func _is_in_any_fog(pos: Vector2) -> bool:
	for zone_center in _fog_zones:
		if pos.distance_to(zone_center) <= FOG_RADIUS:
			return true
	return false

