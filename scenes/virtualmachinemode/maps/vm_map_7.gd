extends VMWaveChallenge

const TOTAL_WAVES := 7

const INITIAL_INTERVAL := 8.0
const MIN_INTERVAL := 5.0
const INTERVAL_STEP := (INITIAL_INTERVAL - MIN_INTERVAL) / float(TOTAL_WAVES - 1)

const SENTINEL_ROLL_CHANCE := 0.20
const SESSION_START_DELAY := 1.0
const IDPS_BOOST_WEIGHT := 1.7 

const WAVES: Array[Dictionary] = [
	{
		"name": "First Contact",
		"composition": {Data.Enemy.SPAM: 14, Data.Enemy.VIRUS: 12, Data.Enemy.ADWARE: 8},
		"spawn_interval": 0.90,
		"hp_mult": 1.00,
	},
	{
		"name": "Escalation",
		"composition": {Data.Enemy.VIRUS: 12, Data.Enemy.WORM: 14, Data.Enemy.SPYWARE: 10, Data.Enemy.BOTNET: 6},
		"spawn_interval": 0.85,
		"hp_mult": 1.08,
	},
	{
		"name": "Credential Theft",
		"composition": {Data.Enemy.CREDS: 14, Data.Enemy.SPYWARE: 12, Data.Enemy.BOTNET: 10, Data.Enemy.TROJAN: 8},
		"spawn_interval": 0.80,
		"hp_mult": 1.15,
	},
	{
		"name": "Insider Access",
		"composition": {Data.Enemy.INSIDERTHREAT: 14, Data.Enemy.TROJAN: 12, Data.Enemy.BOTNET: 10, Data.Enemy.CREDS: 8},
		"spawn_interval": 0.78,
		"hp_mult": 1.22,
	},
	{
		"name": "Database Breach",
		"composition": {Data.Enemy.SQL: 14, Data.Enemy.ROOTKIT: 12, Data.Enemy.INSIDERTHREAT: 10, Data.Enemy.TROJAN: 8},
		"spawn_interval": 0.75,
		"hp_mult": 1.30,
	},
	{
		"name": "Flood Prep",
		"composition": {Data.Enemy.DDOS: 8, Data.Enemy.ROOTKIT: 12, Data.Enemy.SQL: 10, Data.Enemy.RANSOMWARE: 8},
		"spawn_interval": 0.72,
		"hp_mult": 1.35,
	},
	{
		"name": "NotPetya",
		"boss": Data.Enemy.BOSS4,
		"composition": {Data.Enemy.DDOS: 10, Data.Enemy.RANSOMWARE: 12, Data.Enemy.ROOTKIT: 10, Data.Enemy.SQL: 10},
		"spawn_interval": 0.70,
		"hp_mult": 1.40,
	},
]

var _belt
var _belt_timer: Timer
var _current_interval: float = INITIAL_INTERVAL
var _seeded_first_item: bool = false
var _idps_offered: bool = false
var _force_idps_next_roll: bool = false 

const INSIDER_WAVE_INDEX := 3


func _use_story_wave_position() -> bool:
	return true


func _wave_challenge_setup() -> void:
	Data.clear_notpetya_enemy_speed_effect()
	Data.free_towers.clear()
	Data.money = 0
	Economy.gold_multiplier = 0.0

	Data.vm_belt = []
	Data.vm_belt_next_id = 1
	Data.vm_belt_selected_id = -1
	_seeded_first_item = false
	_idps_offered = false
	_force_idps_next_roll = false
	_current_interval = INITIAL_INTERVAL

	_belt = preload("res://scenes/virtualmachinemode/vm_belt.gd").new()
	ui_node.get_node("Control/TextureRect").add_child(_belt)
	_belt.setup(ui_node)

	_belt_timer = Timer.new()
	_belt_timer.one_shot = false
	_belt_timer.wait_time = INITIAL_INTERVAL
	_belt_timer.timeout.connect(_on_belt_timer_tick)
	add_child(_belt_timer)

	call_deferred("_hide_tower_ui_for_belt")


func _hide_tower_ui_for_belt() -> void:
	var scroll = ui_node.get_node_or_null("Control/TextureRect/ScrollContainer")
	if scroll:
		scroll.visible = false

	var toggle_btn = ui_node.get_node_or_null("Control/TextureRect/HBoxContainer/TowerEnemiesButton")
	if toggle_btn:
		toggle_btn.visible = false

	var skills = ui_node.get_node_or_null("Control/HBoxContainer")
	if skills:
		skills.visible = false


func _on_session_started() -> void:
	await get_tree().create_timer(SESSION_START_DELAY, false).timeout
	if not is_inside_tree() or session_ended:
		return

	if not _seeded_first_item:
		_seed_first_belt_item()
		_seeded_first_item = true

	_arm_idps_guarantee()

	_current_interval = _interval_for_wave(_waves_cleared)
	_belt_timer.wait_time = _current_interval
	_belt_timer.start()

	super._on_session_started()


func _seed_first_belt_item() -> void:
	var item := _roll_belt_item(false)
	if item.is_empty():
		return
	Data.vm_belt.append(item)
	_note_belt_item(item)
	Data.vm_belt_changed.emit()


func _on_belt_timer_tick() -> void:
	if not session_active:
		return
	if Data.vm_belt.size() >= 5:
		return
	var item := _roll_belt_item()
	if item.is_empty():
		return
	Data.vm_belt.append(item)
	_note_belt_item(item)
	Data.vm_belt_changed.emit()


func _note_belt_item(item: Dictionary) -> void:
	if item.get("kind") == "tower" and int(item.get("type", -1)) == int(Data.Tower.IDPS):
		_idps_offered = true

func _arm_idps_guarantee() -> void:
	if _idps_offered or _force_idps_next_roll:
		return
	if _waves_cleared < INSIDER_WAVE_INDEX:
		return
	if not Data.TOWER_DATA[Data.Tower.IDPS].get('isUnlocked', false):
		return 

	_force_idps_next_roll = true


func _interval_for_wave(wave_index: int) -> float:
	return max(MIN_INTERVAL, INITIAL_INTERVAL - INTERVAL_STEP * wave_index)


func _roll_belt_item(allow_boost: bool = true) -> Dictionary:
	if allow_boost and _force_idps_next_roll:
		_force_idps_next_roll = false
		if Data.TOWER_DATA[Data.Tower.IDPS].get('isUnlocked', false):
			return {"id": _next_belt_id(), "kind": "tower", "type": int(Data.Tower.IDPS)}

	var sentinel_candidates: Array = []
	for sentinel_enum in Data.Sentinel.values():
		if not Data.SENTINEL_DATA[sentinel_enum].get('isUnlocked', false):
			continue
		if _is_sentinel_deployed(sentinel_enum):
			continue
		if _sentinel_on_belt(sentinel_enum):
			continue
		sentinel_candidates.append(sentinel_enum)

	var tower_candidates: Array = []
	for tower_enum in Data.Tower.values():
		if tower_enum == Data.Tower.BACKUP_SERVER:
			continue
		if Data.TOWER_DATA[tower_enum].get('isUnlocked', false):
			tower_candidates.append(tower_enum)

	var roll_sentinel: bool = not sentinel_candidates.is_empty() and randf() < SENTINEL_ROLL_CHANCE
	if roll_sentinel:
		return {"id": _next_belt_id(), "kind": "sentinel", "type": int(sentinel_candidates.pick_random())}

	if not tower_candidates.is_empty():
		var chosen_tower: int = _pick_tower_candidate(tower_candidates, allow_boost)
		return {"id": _next_belt_id(), "kind": "tower", "type": chosen_tower}

	if not sentinel_candidates.is_empty():
		return {"id": _next_belt_id(), "kind": "sentinel", "type": int(sentinel_candidates.pick_random())}

	return {}


func _pick_tower_candidate(tower_candidates: Array, allow_boost: bool) -> int:
	var boost_active: bool = (
		allow_boost
		and not _idps_offered
		and _waves_cleared < INSIDER_WAVE_INDEX
		and tower_candidates.has(Data.Tower.IDPS)
	)
	if not boost_active:
		return int(tower_candidates.pick_random())

	var total_weight := 0.0
	var weights: Array = []
	for t in tower_candidates:
		var w: float = IDPS_BOOST_WEIGHT if int(t) == int(Data.Tower.IDPS) else 1.0
		weights.append(w)
		total_weight += w

	var roll := randf() * total_weight
	var cumulative := 0.0
	for i in range(tower_candidates.size()):
		cumulative += weights[i]
		if roll < cumulative:
			return int(tower_candidates[i])

	return int(tower_candidates[tower_candidates.size() - 1]) 

	
func _next_belt_id() -> int:
	var id := Data.vm_belt_next_id
	Data.vm_belt_next_id += 1
	return id


func _is_sentinel_deployed(sentinel_enum: int) -> bool:
	match sentinel_enum:
		Data.Sentinel.ETHICAL:
			return Data.sentinel_ethical_deployed
		Data.Sentinel.SYSAD:
			return Data.sentinel_sysad_deployed
		Data.Sentinel.INTRUSION:
			return Data.sentinel_intrusion_deployed
		Data.Sentinel.SECURITY:
			return Data.sentinel_security_deployed
		Data.Sentinel.MALWARE:
			return Data.sentinel_malware_deployed
		Data.Sentinel.DECEPTION:
			return Data.sentinel_deception_deployed
	return false


func _sentinel_on_belt(sentinel_enum: int) -> bool:
	for item in Data.vm_belt:
		if item["kind"] == "sentinel" and int(item["type"]) == int(sentinel_enum):
			return true
	return false


func _total_waves() -> int:
	return TOTAL_WAVES


func _wave_for_index(wave_index: int) -> Dictionary:
	return WAVES[wave_index]


func _on_intermission_started() -> void:
	_current_interval = _interval_for_wave(_waves_cleared)
	if _belt_timer:
		_belt_timer.wait_time = _current_interval
	_arm_idps_guarantee()


func _on_session_ended() -> void:
	super._on_session_ended()
	if _belt_timer:
		_belt_timer.stop()


func _serialize_progress() -> Dictionary:
	var progress := super._serialize_progress()

	var saved_belt: Array = []
	for item in Data.vm_belt:
		saved_belt.append({"id": int(item["id"]), "kind": str(item["kind"]), "type": int(item["type"])})
	progress["belt"] = saved_belt
	progress["seeded"] = _seeded_first_item
	progress["idps_offered"] = _idps_offered
	progress["force_idps_next_roll"] = _force_idps_next_roll

	return progress


func _restore_progress(progress: Dictionary) -> void:
	super._restore_progress(progress)

	Data.vm_belt = []
	var saved_belt: Array = progress.get("belt", [])
	for raw_item in saved_belt:
		Data.vm_belt.append({
			"id": int(raw_item.get("id", 0)),
			"kind": str(raw_item.get("kind", "tower")),
			"type": int(raw_item.get("type", 0)),
		})

	var max_id := 0
	for item in Data.vm_belt:
		max_id = max(max_id, int(item["id"]))
	Data.vm_belt_next_id = max_id + 1

	_seeded_first_item = bool(progress.get("seeded", _waves_cleared > 0))
	_idps_offered = bool(progress.get("idps_offered", false))
	_force_idps_next_roll = bool(progress.get("force_idps_next_roll", false))
	_current_interval = _interval_for_wave(_waves_cleared)
	if _belt_timer:
		_belt_timer.wait_time = _current_interval

	_belt.sync_visuals_instant()

