extends VMChallenge

const KILL_TARGET := 1000
const SPAWN_INTERVAL := 1.0
const WORM_BUDGET := 500
const SPAM_BUDGET := 500
const RUN_MIN := 1
const RUN_MAX := 5

const DIFFICULTY_KILL_INTERVAL := 200
const MAX_DIFFICULTY_LEVEL := 5
const LEVEL_HP_MULTIPLIER := 1.35
const LEVEL_SPEED_MULTIPLIER := 1.15
const LEVEL_SPAWN_DECREASE := 0.20
const MIN_SPAWN_INTERVAL := 0.25
const MAX_ENEMY_SPEED := 260
const MAX_ENEMY_HEALTH := 500

var enemy_kills: int = 0
var difficulty_level: int = 1

var spawn_timer: Timer
var _spawn_tick_active: bool = false

var _budget: Dictionary = {}
var _run_type: int = Data.Enemy.WORM
var _run_left: int = 0


func _challenge_setup() -> void:
	Data.max_health = 1
	Data.health = 1
	Data.clear_notpetya_enemy_speed_effect()

	_budget = {Data.Enemy.WORM: WORM_BUDGET, Data.Enemy.SPAM: SPAM_BUDGET}
	_run_left = 0
	difficulty_level = 1

	spawn_timer = Timer.new()
	spawn_timer.wait_time = SPAWN_INTERVAL
	spawn_timer.timeout.connect(_on_spawn_tick)
	add_child(spawn_timer)


func _on_session_started() -> void:
	spawn_timer.start()


func _on_session_ended() -> void:
	spawn_timer.stop()
	_spawn_tick_active = false


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


# Pure function of the kill count, recomputed rather than incremented - so a kill
# count that jumps (resume, catch-up) or repeats (idempotent re-checks) always
# lands on the correct level with no skipped or double-fired milestone.
func _level_for_kills(kills: int) -> int:
	@warning_ignore("integer_division")
	var steps: int = max(kills, 0) / DIFFICULTY_KILL_INTERVAL
	return clampi(1 + steps, 1, MAX_DIFFICULTY_LEVEL)


func _spawn_interval_for_level(level: int) -> float:
	return max(SPAWN_INTERVAL - (LEVEL_SPAWN_DECREASE * (level - 1)), MIN_SPAWN_INTERVAL)


# Keeps a full lane group's spawn stagger inside a single spawn tick, so a shorter
# interval at high difficulty can never let ticks overlap (see _on_spawn_tick guard).
func _stagger_for_level(level: int) -> float:
	return min(wave_manager.LANE_GROUP_SPAWN_STAGGER, _spawn_interval_for_level(level) / DEFAULT_LANE_COUNT)


func _apply_spawn_interval() -> void:
	spawn_timer.wait_time = _spawn_interval_for_level(difficulty_level)
	# Only restart a timer that's actually running - the spawn budget can already
	# be exhausted (spawn_timer.stop() in _on_spawn_tick), and a difficulty sync
	# firing after that must not resurrect a spawner that has legitimately ended.
	if not spawn_timer.is_stopped():
		spawn_timer.stop()
		spawn_timer.start()


func _sync_difficulty_level() -> void:
	var new_level := _level_for_kills(enemy_kills)
	if new_level == difficulty_level:
		return
	difficulty_level = new_level
	_apply_spawn_interval()


# Only ever called on freshly spawned enemies (via _spawn_lane_group's callback),
# never on enemies already on the path.
func _apply_difficulty(enemy: Node) -> void:
	if enemy == null or difficulty_level <= 1:
		return
	var steps: int = difficulty_level - 1

	var hp: int = int(round(enemy.health * pow(LEVEL_HP_MULTIPLIER, steps)))
	enemy.health = clampi(hp, 1, MAX_ENEMY_HEALTH)
	var hpbar = enemy.get_node_or_null("hpbar")
	if hpbar:
		hpbar.max_value = enemy.health
		hpbar.value = enemy.health

	var spd: int = int(round(enemy.speed * pow(LEVEL_SPEED_MULTIPLIER, steps)))
	enemy.speed = clampi(spd, 1, MAX_ENEMY_SPEED)
	# base_speed must track speed too - update_spyware_buff() (enemy.gd) resets
	# speed from base_speed every frame whenever a Spyware is alive on the map.
	enemy.base_speed = enemy.speed


func _on_spawn_tick() -> void:
	if not session_active or _spawn_tick_active:
		return

	var types: Array = []
	for _i in range(DEFAULT_LANE_COUNT):
		var enemy_type := _next_spawn_type()
		if enemy_type == -1:
			break
		types.append(enemy_type)

	if types.is_empty():
		spawn_timer.stop()
		return

	_spawn_tick_active = true
	await _spawn_lane_group(types, [], _apply_difficulty, _stagger_for_level(difficulty_level))
	_spawn_tick_active = false


func _on_challenge_enemy_killed(_enemy_type: Data.Enemy, _new_count: int) -> void:
	if not session_active:
		return

	enemy_kills += 1
	_refresh_progress_label()

	if enemy_kills >= KILL_TARGET:
		_end_session(true)
		return

	_sync_difficulty_level()


func _on_challenge_server_damaged(_amount: float) -> void:
	_end_session(false)


func _progress_text() -> String:
	return "Enemies %d/%d" % [enemy_kills, KILL_TARGET]


func _result_text(_won: bool) -> String:
	return "Defeated %d / %d enemies" % [enemy_kills, KILL_TARGET]


func _serialize_progress() -> Dictionary:
	return {"enemy_kills": enemy_kills, "difficulty_level": difficulty_level}


func _restore_progress(progress: Dictionary) -> void:
	enemy_kills = int(progress.get("enemy_kills", 0))
	var remaining: int = max(KILL_TARGET - enemy_kills, 0)
	var worm_share: int = int(ceil(remaining / 2.0))
	_budget[Data.Enemy.WORM] = worm_share
	_budget[Data.Enemy.SPAM] = remaining - worm_share

	# Re-derived from kills, never trusted from the save - same rule as the
	# budget re-derivation above, so a stale/edited save can't desync difficulty.
	difficulty_level = _level_for_kills(enemy_kills)
	_apply_spawn_interval()

	if progress.has("health"):
		Data.health = float(progress["health"])

