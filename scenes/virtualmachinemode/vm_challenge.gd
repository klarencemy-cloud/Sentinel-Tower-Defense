extends Node2D
class_name VMChallenge

const VM_SAVE_INTERVAL := 5.0

const LANE_SPACING := 32.0
const DEFAULT_LANE_COUNT := 3

var session_active: bool = false
var session_ended: bool = false
var _scripted_drain_guard: bool = false

var vm_save_timer: Timer

var ui_node: Node
var wave_manager: Node
var wave_button: TextureButton
var progress_label: Label
var countdown_label: Label

var end_overlay: CanvasLayer


func _ready() -> void:
	add_to_group("vmmode_session")

	ui_node = $Level/UI
	wave_manager = $Level/WaveManager
	var wave_num_label: Label = ui_node.get_node("Control/TextureRect/PlayerCurrentStats/WaveNum")
	wave_num_label.visible = false
	if _use_story_wave_position():
		progress_label = ui_node.get_node("Control/TextureRect/PlayerCurrentStats/VMWaveNum")
	else:
		progress_label = ui_node.get_node("Control/VirusNum")
	progress_label.visible = true
	countdown_label = ui_node.get_node_or_null("Control/WaveCountdown")
	wave_button = ui_node.get_node("Control/TextureRect/HBoxContainer/WaveButton")

	var auto_label = ui_node.get_node_or_null("Control/AutoLabel")
	if auto_label:
		auto_label.visible = false

	Data.current_wave = 1
	session_active = false

	Data.money = Data.default_money

	EnemyStats.enemy_killed.connect(_on_challenge_enemy_killed)

	vm_save_timer = Timer.new()
	vm_save_timer.wait_time = VM_SAVE_INTERVAL
	vm_save_timer.timeout.connect(_on_vm_save_tick)
	add_child(vm_save_timer)

	_challenge_setup()
	_restore_progress(Data.vmmode_resume_progress)
	_restore_stats_counters(Data.vmmode_resume_progress)
	if Data.vmmode_resume_progress.has("money"):
		Data.money = int(Data.vmmode_resume_progress["money"])
	_refresh_progress_label()

	_build_end_overlay()

	wave_button.visible = true


func _exit_tree() -> void:
	if EnemyStats.enemy_killed.is_connected(_on_challenge_enemy_killed):
		EnemyStats.enemy_killed.disconnect(_on_challenge_enemy_killed)


func _on_wave_button_pressed() -> void:
	if session_active:
		return
	session_active = true
	wave_button.visible = false
	vm_save_timer.start()
	_on_session_started()


func _on_vm_save_tick() -> void:
	if session_active:
		VMSave.save_game()


func _apply_scripted_drain(amount: float) -> void:
	_scripted_drain_guard = true
	Data.health -= amount
	_scripted_drain_guard = false


func _on_server_damaged(_amount: float) -> void:
	if not session_active or _scripted_drain_guard:
		return
	_on_challenge_server_damaged(_amount)


func _on_server_health_depleted() -> void:
	if not session_active:
		return
	_end_session(false)


func _end_session(won: bool) -> void:
	_halt_session_activity()
	session_ended = true
	vm_save_timer.stop()
	VMSave.clear_save(Data.vmmode_map_number)

	if won:
		Data.grant_vm_map_reward(Data.vmmode_map_number)
		$Level.level_completed()
	else:
		end_overlay.show_result(false, _result_text(false))
		get_tree().paused = true


# Stops the challenge's own spawn/timer logic and clears any enemies/bullets
# still active, so combat doesn't keep visibly running after the player has left
# the session, however they left it. Relying on scene teardown alone leaves a
# window where the old tree - and its still-ticking spawn timer - keeps running:
# quitting mid-session from the pause menu (pause_menu.gd -> call_group
# ("vmmode_session", "_on_quit_pressed")) bypasses _end_session entirely, so this
# must be called from every exit path (_end_session, retry, quit), not just win.
func _halt_session_activity() -> void:
	session_active = false
	_on_session_ended()
	_clear_remaining_combat()
	_hide_countdown()


func _clear_remaining_combat() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	for bullet in get_tree().get_nodes_in_group("bullet"):
		bullet.queue_free()


func _restore_stats_counters(progress: Dictionary) -> void:
	var stats: Dictionary = progress.get("stats", {})
	if stats.has("enemy_kills"):
		EnemyStats.load_save_data(stats["enemy_kills"])
	if stats.has("tower_damage"):
		EnemyTower.load_damage_save_data(stats["tower_damage"])


func _refresh_progress_label() -> void:
	if progress_label:
		progress_label.text = _progress_text()


func _set_countdown_text(text: String) -> void:
	if countdown_label:
		countdown_label.text = text
		countdown_label.visible = true


func _hide_countdown() -> void:
	if countdown_label:
		countdown_label.visible = false


func _restore_backed_up_state() -> void:
	Data.current_level_index = Data.before_level_index
	Data.current_wave = Data.before_current_wave
	Data.money = Data.before_total_money
	Data.max_health = Data.before_max_health
	Data.health = Data.before_total_health
	Data.maxserverload = Data.before_max_server_load
	Data.currentserverload = Data.before_current_server_load
	Data.server_points = Data.before_server_points
	Data.free_towers = Data.before_free_towers.duplicate()

	Data._restore_tower_upgrades()
	Offense._restore_original_server_stats()
	Defense._restore_original_server_stats()
	Economy._restore_original_server_stats()

	EnemyStats.restore_backup()
	EnemyTower.restore_backup()

	Data.is_vmmode = false
	Data.vmmode_sentinels_disabled = false
	Data.vm_belt = []
	Data.vm_belt_selected_id = -1


func _on_retry_pressed() -> void:
	UISound.play_click()
	get_tree().paused = false
	_halt_session_activity()
	VMSave.clear_save(Data.vmmode_map_number)
	Data.currentserverload = 0
	Data.vmmode_resume_progress = {}
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_quit_pressed() -> void:
	UISound.play_click()
	get_tree().paused = false
	_halt_session_activity()
	if not session_ended:
		VMSave.save_game()
	_restore_backed_up_state()
	get_tree().change_scene_to_file("res://scenes/game mode/gamemode.tscn")


func _build_end_overlay() -> void:
	var overlay_scene := preload("res://scenes/virtualmachinemode/vm_game_over.tscn")
	end_overlay = overlay_scene.instantiate()
	add_child(end_overlay)
	end_overlay.retry_pressed.connect(_on_retry_pressed)
	end_overlay.quit_pressed.connect(_on_quit_pressed)


static func lane_offsets_for(count: int, spacing: float = LANE_SPACING) -> Array:
	var offsets: Array = []
	for i in range(count):
		offsets.append((float(i) - (count - 1) / 2.0) * spacing)
	return offsets


func _spawn_lane_group(enemy_types: Array, lane_offsets: Array = [], on_enemy_spawned: Callable = Callable(), spawn_stagger: float = -1.0) -> Array:
	if wave_manager == null or enemy_types.is_empty():
		return []
	if lane_offsets.is_empty():
		lane_offsets = lane_offsets_for(enemy_types.size())
	var guarded_callback := func(enemy: Node) -> void:
		if not session_active:
			if enemy:
				enemy.queue_free()
			return
		if on_enemy_spawned.is_valid():
			on_enemy_spawned.call(enemy)
	var stagger: float = wave_manager.LANE_GROUP_SPAWN_STAGGER if spawn_stagger < 0.0 else spawn_stagger
	return await wave_manager.spawn_enemy_lane_group(enemy_types, null, lane_offsets, stagger, guarded_callback)


func _use_story_wave_position() -> bool:
	return false


func _challenge_setup() -> void:
	pass


func _on_session_started() -> void:
	pass


func _on_session_ended() -> void:
	pass


func _on_challenge_enemy_killed(_enemy_type: Data.Enemy, _new_count: int) -> void:
	pass


func _on_challenge_server_damaged(_amount: float) -> void:
	pass


func _progress_text() -> String:
	return ""


func _serialize_progress() -> Dictionary:
	return {}


func _restore_progress(_progress: Dictionary) -> void:
	pass


func _result_text(_won: bool) -> String:
	return ""
