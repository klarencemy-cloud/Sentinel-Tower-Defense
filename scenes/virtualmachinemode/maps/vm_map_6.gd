extends VMChallenge

const KILL_TARGET := 260
const PARENT_BUDGET := 75
const TIME_LIMIT := 300.0
const SPAWN_INTERVAL := 2.0
const LANE_RAMP_LANE_COUNT := 2
const LANE_RAMP_PARENT_THRESHOLD := 30
const STARTING_GOLD := 225

var _ddos_kills: int = 0
var _ddos_spawned: int = 0
var _seconds_left: int = 0

var spawn_timer: Timer
var countdown_timer: Timer
var _spawn_tick_active: bool = false


func _challenge_setup() -> void:
	Data.health = Data.max_health
	Data.clear_notpetya_enemy_speed_effect()
	Data.money = STARTING_GOLD

	_ddos_kills = 0
	_ddos_spawned = 0
	_seconds_left = int(TIME_LIMIT)

	spawn_timer = Timer.new()
	spawn_timer.wait_time = SPAWN_INTERVAL
	spawn_timer.timeout.connect(_on_spawn_tick)
	add_child(spawn_timer)

	countdown_timer = Timer.new()
	countdown_timer.wait_time = 1.0
	countdown_timer.timeout.connect(_on_countdown_tick)
	add_child(countdown_timer)

	_update_countdown_label()


func _on_session_started() -> void:
	spawn_timer.start()
	countdown_timer.start()
	_update_countdown_label()


func _on_session_ended() -> void:
	spawn_timer.stop()
	countdown_timer.stop()
	_spawn_tick_active = false


func _on_spawn_tick() -> void:
	if not session_active or _spawn_tick_active:
		return
	if _ddos_spawned >= PARENT_BUDGET:
		spawn_timer.stop()
		return

	var paths: Array = wave_manager._get_paths()
	if paths.is_empty():
		return
	if _ddos_spawned < LANE_RAMP_PARENT_THRESHOLD:
		paths = paths.slice(0, mini(LANE_RAMP_LANE_COUNT, paths.size()))

	_spawn_tick_active = true
	for path in paths:
		if not session_active or _ddos_spawned >= PARENT_BUDGET:
			break
		await wave_manager.spawn_enemy_lane_group([Data.Enemy.DDOS], path, [0.0], 0.0)
		_ddos_spawned += 1
	_spawn_tick_active = false


func _on_countdown_tick() -> void:
	if not session_active:
		countdown_timer.stop()
		return

	_seconds_left -= 1
	if _seconds_left <= 0:
		_seconds_left = 0
		_update_countdown_label()
		_end_session(false)
		return

	_update_countdown_label()


func _update_countdown_label() -> void:
	var minutes: int = _seconds_left / 60
	var seconds: int = _seconds_left % 60
	_set_countdown_text("%d:%02d" % [minutes, seconds])


func _on_challenge_enemy_killed(enemy_type: Data.Enemy, new_count: int) -> void:
	if not session_active:
		return
	if enemy_type != Data.Enemy.DDOS:
		return

	_ddos_kills = new_count
	_refresh_progress_label()

	if _ddos_kills >= KILL_TARGET:
		_end_session(true)


func _progress_text() -> String:
	return "DDoS %d/%d" % [_ddos_kills, KILL_TARGET]


func _result_text(_won: bool) -> String:
	return "Defeated %d / %d DDoS" % [_ddos_kills, KILL_TARGET]


func _serialize_progress() -> Dictionary:
	return {
		"ddos_kills": _ddos_kills,
		"seconds_left": _seconds_left,
	}


func _restore_progress(progress: Dictionary) -> void:
	_ddos_kills = int(progress.get("ddos_kills", 0))
	_ddos_kills = clampi(_ddos_kills, 0, KILL_TARGET)

	@warning_ignore("integer_division")
	var derived_spawned: int = _ddos_kills / 4
	_ddos_spawned = derived_spawned

	_seconds_left = int(progress.get("seconds_left", TIME_LIMIT))
	_seconds_left = clampi(_seconds_left, 0, int(TIME_LIMIT))
	_update_countdown_label()

	if progress.has("health"):
		Data.health = float(progress["health"])
