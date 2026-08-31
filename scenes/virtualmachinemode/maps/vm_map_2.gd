extends VMChallenge

const KILL_TARGET := 1000
const SPAWN_INTERVAL := 1.0
const WORM_BUDGET := 500
const SPAM_BUDGET := 500
const RUN_MIN := 1
const RUN_MAX := 5

var enemy_kills: int = 0

var spawn_timer: Timer

var _budget: Dictionary = {}
var _run_type: int = Data.Enemy.WORM
var _run_left: int = 0


func _challenge_setup() -> void:
	Data.max_health = 1
	Data.health = 1

	_budget = {Data.Enemy.WORM: WORM_BUDGET, Data.Enemy.DEFAULT: SPAM_BUDGET}
	_run_left = 0

	spawn_timer = Timer.new()
	spawn_timer.wait_time = SPAWN_INTERVAL
	spawn_timer.timeout.connect(_on_spawn_tick)
	add_child(spawn_timer)


func _on_session_started() -> void:
	spawn_timer.start()


func _on_session_ended() -> void:
	spawn_timer.stop()


func _next_spawn_type() -> int:
	if _run_left <= 0 or _budget.get(_run_type, 0) <= 0:
		var avail: Array = []
		for t in _budget:
			if _budget[t] > 0:
				avail.append(t)
		if avail.is_empty():
			return -1
		_run_type = avail.pick_random()
		_run_left = randi_range(RUN_MIN, RUN_MAX)
	_run_left -= 1
	_budget[_run_type] -= 1
	return _run_type


func _on_spawn_tick() -> void:
	if not session_active:
		return
	var enemy_type := _next_spawn_type()
	if enemy_type == -1:
		spawn_timer.stop()
		return
	var wave_manager = $Level/WaveManager
	if wave_manager:
		wave_manager.spawn_sandbox_enemy(enemy_type)


func _on_challenge_enemy_killed(_enemy_type: Data.Enemy, _new_count: int) -> void:
	if not session_active:
		return

	enemy_kills += 1
	_refresh_progress_label()

	if enemy_kills >= KILL_TARGET:
		_end_session(true)


func _on_challenge_server_damaged(_amount: float) -> void:
	_end_session(false)


func _progress_text() -> String:
	return "Enemies %d/%d" % [enemy_kills, KILL_TARGET]


func _result_text(_won: bool) -> String:
	return "Defeated %d / %d enemies" % [enemy_kills, KILL_TARGET]


func _serialize_progress() -> Dictionary:
	return {
		"enemy_kills": enemy_kills,
		"worm_budget": _budget.get(Data.Enemy.WORM, 0),
		"spam_budget": _budget.get(Data.Enemy.DEFAULT, 0),
	}


func _restore_progress(progress: Dictionary) -> void:
	enemy_kills = int(progress.get("enemy_kills", 0))
	if progress.has("worm_budget"):
		_budget[Data.Enemy.WORM] = int(progress["worm_budget"])
	if progress.has("spam_budget"):
		_budget[Data.Enemy.DEFAULT] = int(progress["spam_budget"])
	if progress.has("health"):
		Data.health = float(progress["health"])
