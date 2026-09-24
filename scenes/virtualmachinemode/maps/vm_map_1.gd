extends VMChallenge

const VIRUS_TARGET := 200
const SPAWN_INTERVAL := 1.0
const DRAIN_INTERVAL := 5.0
const DRAIN_AMOUNT := 4.0

const TIER_KILL_INTERVAL := 50
const TIER_SPAWN_DECREASE := 0.2
const TIER_HP_MULTIPLIER := 1.35
const TIER_HP_MULTIPLIER_LATE := 1.25 
const TIER_SPEED_MULTIPLIER := 1.5
const TIER_SPEED_MULTIPLIER_LATE := 1.2 
const MIN_SPAWN_INTERVAL := 0.1

var virus_kills: int = 0
var virus_spawned: int = 0
var difficulty_tier: int = 0

var spawn_timer: Timer
var drain_timer: Timer


func _challenge_setup() -> void:
	Data.health = Data.max_health

	spawn_timer = Timer.new()
	spawn_timer.wait_time = SPAWN_INTERVAL
	spawn_timer.timeout.connect(_on_spawn_tick)
	add_child(spawn_timer)

	drain_timer = Timer.new()
	drain_timer.wait_time = DRAIN_INTERVAL
	drain_timer.timeout.connect(_on_drain_tick)
	add_child(drain_timer)


func _on_session_started() -> void:
	spawn_timer.start()
	drain_timer.start()


func _on_session_ended() -> void:
	spawn_timer.stop()
	drain_timer.stop()


func _on_spawn_tick() -> void:
	if not session_active:
		return
	if virus_spawned >= VIRUS_TARGET:
		spawn_timer.stop()
		return
	var wave_manager = $Level/WaveManager
	if wave_manager:
		var enemy = wave_manager.spawn_sandbox_enemy(Data.Enemy.VIRUS)
		if enemy:
			virus_spawned += 1
			if difficulty_tier > 0:
				_apply_virus_difficulty(enemy)


func _apply_virus_difficulty(enemy: Node) -> void:
	var hp_multiplier: float
	var speed_multiplier: float
	if difficulty_tier <= 2:
		hp_multiplier = pow(TIER_HP_MULTIPLIER, difficulty_tier)
		speed_multiplier = pow(TIER_SPEED_MULTIPLIER, difficulty_tier)
	else:
		hp_multiplier = pow(TIER_HP_MULTIPLIER, 2) * pow(TIER_HP_MULTIPLIER_LATE, difficulty_tier - 2)
		speed_multiplier = pow(TIER_SPEED_MULTIPLIER, 2) * pow(TIER_SPEED_MULTIPLIER_LATE, difficulty_tier - 2)

	enemy.health = max(1, int(enemy.health * hp_multiplier))
	var hpbar = enemy.get_node_or_null("hpbar")
	if hpbar:
		hpbar.max_value = enemy.health
		hpbar.value = enemy.health
	enemy.speed = int(enemy.speed * speed_multiplier)
	enemy.base_speed = enemy.speed


func _spawn_interval_for_tier(tier: int) -> float:
	return max(SPAWN_INTERVAL - (TIER_SPAWN_DECREASE * tier), MIN_SPAWN_INTERVAL)


func _advance_difficulty_tier() -> void:
	difficulty_tier += 1
	if virus_spawned >= VIRUS_TARGET:
		return
	spawn_timer.stop()
	spawn_timer.wait_time = _spawn_interval_for_tier(difficulty_tier)
	spawn_timer.start()


func _on_drain_tick() -> void:
	if not session_active:
		return
	_apply_scripted_drain(DRAIN_AMOUNT)


func _on_challenge_enemy_killed(enemy_type: Data.Enemy, _new_count: int) -> void:
	if not session_active:
		return
	if enemy_type != Data.Enemy.VIRUS:
		return

	virus_kills += 1
	_refresh_progress_label()

	if virus_kills % TIER_KILL_INTERVAL == 0 and virus_kills < VIRUS_TARGET:
		_advance_difficulty_tier()

	if virus_kills >= VIRUS_TARGET:
		_end_session(true)


func _progress_text() -> String:
	return "Virus %d/%d" % [virus_kills, VIRUS_TARGET]


func _result_text(_won: bool) -> String:
	return "Defeated %d / %d viruses" % [virus_kills, VIRUS_TARGET]


func _serialize_progress() -> Dictionary:
	return {"virus_kills": virus_kills, "difficulty_tier": difficulty_tier}


func _restore_progress(progress: Dictionary) -> void:
	virus_kills = int(progress.get("virus_kills", 0))
	virus_spawned = virus_kills

	@warning_ignore("integer_division")
	var default_tier: int = virus_kills / TIER_KILL_INTERVAL
	difficulty_tier = int(progress.get("difficulty_tier", default_tier))
	if progress.has("health"):
		Data.health = float(progress["health"])
	if difficulty_tier > 0:
		spawn_timer.wait_time = _spawn_interval_for_tier(difficulty_tier)
