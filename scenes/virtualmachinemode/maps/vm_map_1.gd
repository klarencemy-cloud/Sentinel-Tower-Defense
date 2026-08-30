extends VMChallenge

const VIRUS_TARGET := 200
const SPAWN_INTERVAL := 2.0
const DRAIN_INTERVAL := 5.0
const DRAIN_AMOUNT := 1.0

var virus_kills: int = 0

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
	var wave_manager = $Level/WaveManager
	if wave_manager:
		wave_manager.spawn_sandbox_enemy(Data.Enemy.VIRUS)


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

	if virus_kills >= VIRUS_TARGET:
		_end_session(true)


func _progress_text() -> String:
	return "Virus %d/%d" % [virus_kills, VIRUS_TARGET]


func _result_text(_won: bool) -> String:
	return "Defeated %d / %d viruses" % [virus_kills, VIRUS_TARGET]


func _serialize_progress() -> Dictionary:
	return {"virus_kills": virus_kills}


func _restore_progress(progress: Dictionary) -> void:
	virus_kills = int(progress.get("virus_kills", 0))
	if progress.has("health"):
		Data.health = float(progress["health"])
