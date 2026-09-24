extends VMChallenge
class_name VMWaveChallenge

const INTERMISSION_SECONDS := 10
const WAVE_CLEAR_POLL_INTERVAL := 0.25

const WAVE_HP_MULTIPLIER_MAX := 500
const WAVE_SPEED_MULTIPLIER_MAX := 400

var _waves_cleared: int = 0
var _spawning: bool = false
var _between_waves: bool = false
var _lane_rotation_offset: int = 0

var intermission_timer: Timer
var wave_clear_poll_timer: Timer
var _intermission_seconds_left: int = 0


func _challenge_setup() -> void:
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

	Data.health = Data.max_health

	_wave_challenge_setup()


func _on_session_started() -> void:
	wave_clear_poll_timer.start()
	if _is_endless() or _waves_cleared < _total_waves():
		_start_wave(_waves_cleared)


func _on_session_ended() -> void:
	wave_clear_poll_timer.stop()
	intermission_timer.stop()
	_spawning = false
	_between_waves = false


func _start_wave(wave_index: int) -> void:
	if not _is_endless() and (wave_index < 0 or wave_index >= _total_waves()):
		return
	_between_waves = false
	_hide_countdown()
	_spawning = true
	_refresh_progress_label()
	await _spawn_wave(_wave_for_index(wave_index))
	_spawning = false


func _spawn_wave(wave_data: Dictionary) -> void:
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
		_apply_wave_stats(enemy, wave_data)

	var index := 0
	while index < pool.size():
		if not session_active:
			return
		var chunk_size: int = min(DEFAULT_LANE_COUNT, pool.size() - index)
		var chunk: Array = pool.slice(index, index + chunk_size)
		index += chunk_size

		await _spawn_across_paths(chunk, apply_scaling, stagger)

		if index < pool.size():
			await get_tree().create_timer(spawn_interval, false).timeout


func _spawn_across_paths(enemy_types: Array, on_enemy_spawned: Callable = Callable(), spawn_stagger: float = -1.0) -> void:
	if wave_manager == null or enemy_types.is_empty():
		return

	var paths: Array = wave_manager._get_paths()
	if paths.size() <= 1:
		await _spawn_lane_group(enemy_types, [], on_enemy_spawned, spawn_stagger)
		return

	var per_path: Array = []
	for i in range(paths.size()):
		per_path.append([])
	for i in range(enemy_types.size()):
		per_path[(i + _lane_rotation_offset) % paths.size()].append(enemy_types[i])
	_lane_rotation_offset = (_lane_rotation_offset + enemy_types.size()) % paths.size()

	for path_index in range(paths.size()):
		var chunk: Array = per_path[path_index]
		if chunk.is_empty():
			continue
		if not session_active:
			return
		await wave_manager.spawn_enemy_lane_group(
			chunk,
			paths[path_index],
			lane_offsets_for(chunk.size()),
			spawn_stagger if spawn_stagger >= 0.0 else wave_manager.LANE_GROUP_SPAWN_STAGGER,
			func(enemy: Node) -> void:
				if not session_active:
					if enemy:
						enemy.queue_free()
					return
				if on_enemy_spawned.is_valid():
					on_enemy_spawned.call(enemy)
		)


func _apply_wave_stats(enemy: Node, wave_data: Dictionary) -> void:
	if enemy == null:
		return

	var hp_mult: float = wave_data.get("hp_mult", 1.0)
	var speed_mult: float = wave_data.get("speed_mult", 1.0)
	var hp_override = wave_data.get("hp_override", null)
	var speed_override = wave_data.get("speed_override", null)

	var changed := false

	if hp_override != null:
		enemy.health = clampi(int(hp_override), 1, WAVE_HP_MULTIPLIER_MAX)
		changed = true
	elif hp_mult > 1.0:
		enemy.health = clampi(int(round(enemy.health * hp_mult)), 1, WAVE_HP_MULTIPLIER_MAX)
		changed = true

	if changed:
		var hpbar = enemy.get_node_or_null("hpbar")
		if hpbar:
			hpbar.max_value = enemy.health
			hpbar.value = enemy.health

	if speed_override != null:
		enemy.speed = clampi(int(speed_override), 1, WAVE_SPEED_MULTIPLIER_MAX)
		enemy.base_speed = enemy.speed
	elif speed_mult > 1.0:
		enemy.speed = clampi(int(round(enemy.speed * speed_mult)), 1, WAVE_SPEED_MULTIPLIER_MAX)
		enemy.base_speed = enemy.speed


func _on_wave_clear_poll() -> void:
	if not session_active or _spawning or _between_waves:
		return
	if not get_tree().get_nodes_in_group("Enemies").is_empty():
		return

	_waves_cleared += 1
	_refresh_progress_label()

	if not _is_endless() and _waves_cleared >= _total_waves():
		_end_session(true)
		return

	_begin_intermission()


func _begin_intermission() -> void:
	_between_waves = true
	_intermission_seconds_left = INTERMISSION_SECONDS
	_set_countdown_text("Next wave in %ds" % _intermission_seconds_left)
	intermission_timer.start()
	_on_intermission_started()


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


func _progress_text() -> String:
	if _is_endless():
		return "Wave %d" % (_waves_cleared + 1)
	return "Wave %d/%d" % [mini(_waves_cleared + 1, _total_waves()), _total_waves()]


func _result_text(_won: bool) -> String:
	if _is_endless():
		return "Survived %d waves" % _waves_cleared
	return "Cleared %d / %d waves" % [_waves_cleared, _total_waves()]


func _serialize_progress() -> Dictionary:
	return {"waves_cleared": _waves_cleared}


func _restore_progress(progress: Dictionary) -> void:
	_waves_cleared = int(progress.get("waves_cleared", 0))
	if not _is_endless():
		_waves_cleared = clampi(_waves_cleared, 0, _total_waves())
	if progress.has("health"):
		Data.health = float(progress["health"])


func _wave_challenge_setup() -> void:
	pass


func _total_waves() -> int:
	return 0


func _wave_for_index(_wave_index: int) -> Dictionary:
	return {}


func _is_endless() -> bool:
	return false


func _on_intermission_started() -> void:
	pass
