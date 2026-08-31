extends VMChallenge

const TOTAL_WAVES := 7
const INTERMISSION_SECONDS := 10
const WAVE_CLEAR_POLL_INTERVAL := 0.25

const WAVE_HP_MULTIPLIER_MAX := 500

const WAVES: Array[Dictionary] = [
	{
		"name": "Initial Infection",
		"composition": {Data.Enemy.VIRUS: 18, Data.Enemy.WORM: 6},
		"spawn_interval": 1.10,
		"hp_mult": 1.00,
	},
	{
		"name": "Propagation",
		"composition": {Data.Enemy.VIRUS: 12, Data.Enemy.WORM: 16, Data.Enemy.ADWARE: 8},
		"spawn_interval": 1.00,
		"hp_mult": 1.00,
	},
	{
		"name": "Surveillance",
		"composition": {Data.Enemy.ADWARE: 14, Data.Enemy.SPYWARE: 12, Data.Enemy.WORM: 10},
		"spawn_interval": 0.95,
		"hp_mult": 1.05,
	},
	{
		"name": "Command & Control",
		"composition": {Data.Enemy.BOTNET: 14, Data.Enemy.SPYWARE: 10, Data.Enemy.VIRUS: 12},
		"spawn_interval": 0.90,
		"hp_mult": 1.10,
	},
	{
		"name": "Payload Delivery",
		"composition": {Data.Enemy.TROJAN: 10, Data.Enemy.ROOTKIT: 10, Data.Enemy.BOTNET: 10},
		"spawn_interval": 0.90,
		"hp_mult": 1.15,
	},
	{
		"name": "Encryption",
		"composition": {Data.Enemy.RANSOMWARE: 14, Data.Enemy.ZERO: 8, Data.Enemy.ROOTKIT: 8, Data.Enemy.TROJAN: 6},
		"spawn_interval": 0.85,
		"hp_mult": 1.20,
	},
	{
		"name": "ILOVEYOU",
		"boss": Data.Enemy.BOSS1,
		"composition": {Data.Enemy.WORM: 20, Data.Enemy.BOTNET: 10, Data.Enemy.RANSOMWARE: 8, Data.Enemy.ZERO: 6},
		"spawn_interval": 0.80,
		"hp_mult": 1.25,
	},
]

var _waves_cleared: int = 0
var _spawning: bool = false
var _between_waves: bool = false

var intermission_timer: Timer
var wave_clear_poll_timer: Timer
var _intermission_seconds_left: int = 0


func _challenge_setup() -> void:
	Data.max_health = 1
	Data.health = 1
	Data.clear_notpetya_enemy_speed_effect()

	_waves_cleared = 0
	_spawning = false
	_between_waves = false

	wave_clear_poll_timer = Timer.new()
	wave_clear_poll_timer.wait_time = WAVE_CLEAR_POLL_INTERVAL
	wave_clear_poll_timer.timeout.connect(_on_wave_clear_poll)
	add_child(wave_clear_poll_timer)

	intermission_timer = Timer.new()
	intermission_timer.wait_time = 1.0
	intermission_timer.timeout.connect(_on_intermission_tick)
	add_child(intermission_timer)


func _on_session_started() -> void:
	wave_clear_poll_timer.start()
	if _waves_cleared < TOTAL_WAVES:
		_start_wave(_waves_cleared)


func _on_session_ended() -> void:
	wave_clear_poll_timer.stop()
	intermission_timer.stop()
	_spawning = false
	_between_waves = false


func _start_wave(wave_index: int) -> void:
	if wave_index < 0 or wave_index >= WAVES.size():
		return
	_between_waves = false
	_hide_countdown()
	_spawning = true
	_refresh_progress_label()
	await _spawn_wave(WAVES[wave_index])
	_spawning = false


func _spawn_wave(wave_data: Dictionary) -> void:
	var hp_mult: float = wave_data.get("hp_mult", 1.0)
	var spawn_interval: float = wave_data.get("spawn_interval", 1.0)
	var stagger: float = min(wave_manager.LANE_GROUP_SPAWN_STAGGER, spawn_interval / DEFAULT_LANE_COUNT)

	if wave_data.has("boss"):
		if not session_active:
			return
		await _spawn_lane_group([wave_data["boss"]], [], Callable(), stagger)
		if not session_active:
			return
		await get_tree().create_timer(spawn_interval, false).timeout

	var pool: Array = []
	var composition: Dictionary = wave_data.get("composition", {})
	for enemy_type in composition.keys():
		for i in range(int(composition[enemy_type])):
			pool.append(enemy_type)
	pool.shuffle()

	var apply_scaling := func(enemy: Node) -> void:
		_apply_wave_hp_scaling(enemy, hp_mult)

	var index := 0
	while index < pool.size():
		if not session_active:
			return
		var chunk_size: int = min(DEFAULT_LANE_COUNT, pool.size() - index)
		var chunk: Array = pool.slice(index, index + chunk_size)
		index += chunk_size

		await _spawn_lane_group(chunk, [], apply_scaling, stagger)

		if index < pool.size():
			await get_tree().create_timer(spawn_interval, false).timeout


# Never applied to the boss - only the malware roster's own stats carry the ladder for wave 7.
func _apply_wave_hp_scaling(enemy: Node, hp_mult: float) -> void:
	if enemy == null or hp_mult <= 1.0:
		return

	var hp: int = int(round(enemy.health * hp_mult))
	enemy.health = clampi(hp, 1, WAVE_HP_MULTIPLIER_MAX)
	var hpbar = enemy.get_node_or_null("hpbar")
	if hpbar:
		hpbar.max_value = enemy.health
		hpbar.value = enemy.health

	# base_speed must track speed too - update_spyware_buff() (enemy.gd) resets
	# speed from base_speed every frame whenever a Spyware is alive on the map.
	enemy.base_speed = enemy.speed


func _on_wave_clear_poll() -> void:
	if not session_active or _spawning or _between_waves:
		return
	if not get_tree().get_nodes_in_group("Enemies").is_empty():
		return

	_waves_cleared += 1
	_refresh_progress_label()

	if _waves_cleared >= TOTAL_WAVES:
		_end_session(true)
		return

	_begin_intermission()


func _begin_intermission() -> void:
	_between_waves = true
	_intermission_seconds_left = INTERMISSION_SECONDS
	_set_countdown_text("Next wave in %ds" % _intermission_seconds_left)
	intermission_timer.start()


func _on_intermission_tick() -> void:
	if not session_active:
		intermission_timer.stop()
		return

	_intermission_seconds_left -= 1
	if _intermission_seconds_left <= 0:
		intermission_timer.stop()
		_start_wave(_waves_cleared)
		return

	_set_countdown_text("Next wave in %ds" % _intermission_seconds_left)


func _on_challenge_enemy_killed(_enemy_type: Data.Enemy, _new_count: int) -> void:
	if not session_active:
		return
	_refresh_progress_label()


func _on_challenge_server_damaged(_amount: float) -> void:
	_end_session(false)


func _progress_text() -> String:
	return "Wave %d/%d" % [mini(_waves_cleared + 1, TOTAL_WAVES), TOTAL_WAVES]


func _result_text(_won: bool) -> String:
	return "Cleared %d / %d waves" % [_waves_cleared, TOTAL_WAVES]


func _serialize_progress() -> Dictionary:
	return {"waves_cleared": _waves_cleared}


func _restore_progress(progress: Dictionary) -> void:
	_waves_cleared = int(progress.get("waves_cleared", 0))
	_waves_cleared = clampi(_waves_cleared, 0, TOTAL_WAVES)

	Data.health = 1
