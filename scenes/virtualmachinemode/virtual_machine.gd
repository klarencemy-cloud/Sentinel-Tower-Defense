extends Node2D

const VIRUS_TARGET := 200
const SPAWN_INTERVAL := 2.0
const DRAIN_INTERVAL := 5.0
const DRAIN_AMOUNT := 1.0
const VM_SAVE_INTERVAL := 5.0

var virus_kills: int = 0
var session_active: bool = false
var session_ended: bool = false

var spawn_timer: Timer
var drain_timer: Timer
var vm_save_timer: Timer

var ui_node: Node
var virus_num_label: Label
var wave_button: TextureButton

var end_overlay: CanvasLayer


func _ready() -> void:
	add_to_group("vmmode_session")

	ui_node = $Level/UI
	var wave_num_label: Label = ui_node.get_node("Control/TextureRect/PlayerCurrentStats/WaveNum")
	wave_num_label.visible = false
	virus_num_label = ui_node.get_node("Control/TextureRect/PlayerCurrentStats/VirusNum")
	virus_num_label.visible = true
	wave_button = ui_node.get_node("Control/TextureRect/HBoxContainer/WaveButton")

	var auto_label = ui_node.get_node_or_null("Control/AutoLabel")
	if auto_label:
		auto_label.visible = false

	Data.current_wave = 1
	Data.health = Data.max_health if Data.vmmode_resume_health < 0 else Data.vmmode_resume_health

	virus_kills = Data.vmmode_resume_kills
	session_active = false

	_refresh_progress_label()

	EnemyStats.enemy_killed.connect(_on_enemy_killed)

	spawn_timer = Timer.new()
	spawn_timer.wait_time = SPAWN_INTERVAL
	spawn_timer.timeout.connect(_on_spawn_tick)
	add_child(spawn_timer)

	drain_timer = Timer.new()
	drain_timer.wait_time = DRAIN_INTERVAL
	drain_timer.timeout.connect(_on_drain_tick)
	add_child(drain_timer)

	vm_save_timer = Timer.new()
	vm_save_timer.wait_time = VM_SAVE_INTERVAL
	vm_save_timer.timeout.connect(_on_vm_save_tick)
	add_child(vm_save_timer)

	_build_end_overlay()

	wave_button.visible = true


func _exit_tree() -> void:
	if EnemyStats.enemy_killed.is_connected(_on_enemy_killed):
		EnemyStats.enemy_killed.disconnect(_on_enemy_killed)


func _on_wave_button_pressed() -> void:
	if session_active:
		return
	session_active = true
	wave_button.visible = false
	spawn_timer.start()
	drain_timer.start()
	vm_save_timer.start()


func _on_spawn_tick() -> void:
	if not session_active:
		return
	var wave_manager = $Level/WaveManager
	if wave_manager:
		wave_manager.spawn_sandbox_enemy(Data.Enemy.VIRUS)


func _on_drain_tick() -> void:
	if not session_active:
		return
	Data.health -= DRAIN_AMOUNT


func _on_vm_save_tick() -> void:
	if session_active:
		VMSave.save_game()


func _on_enemy_killed(enemy_type: Data.Enemy, _new_count: int) -> void:
	if not session_active:
		return
	if enemy_type != Data.Enemy.VIRUS:
		return

	virus_kills += 1
	_refresh_progress_label()

	if virus_kills >= VIRUS_TARGET:
		_end_session(true)


func _refresh_progress_label() -> void:
	if virus_num_label:
		virus_num_label.text = "Virus %d/%d" % [virus_kills, VIRUS_TARGET]


func _on_server_health_depleted() -> void:
	if not session_active:
		return
	_end_session(false)


func _end_session(won: bool) -> void:
	session_active = false
	session_ended = true
	spawn_timer.stop()
	drain_timer.stop()
	vm_save_timer.stop()
	VMSave.clear_save()

	end_overlay.show_result(won, virus_kills, VIRUS_TARGET)
	get_tree().paused = true


func _restore_backed_up_state() -> void:
	Data.current_level_index = Data.before_level_index
	Data.current_wave = Data.before_current_wave
	Data.max_health = Data.before_max_health
	Data.health = Data.before_total_health
	Data.maxserverload = Data.before_max_server_load
	Data.currentserverload = Data.before_current_server_load
	Data.server_points = Data.before_server_points

	Data._restore_tower_upgrades()
	Offense._restore_original_server_stats()
	Defense._restore_original_server_stats()
	Economy._restore_original_server_stats()

	Data.is_vmmode = false


func _on_retry_pressed() -> void:
	UISound.play_click()
	get_tree().paused = false
	VMSave.clear_save()
	Data.currentserverload = 0
	Data.vmmode_resume_kills = 0
	Data.vmmode_resume_health = -1.0
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_quit_pressed() -> void:
	UISound.play_click()
	get_tree().paused = false
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
