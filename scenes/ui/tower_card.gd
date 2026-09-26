extends Button

var id: Data.Tower
var cost: int
var credential_disable_sources: Array[Node] = []
const TOWER_COOLDOWN := 5.0
var cooldown_timer := Timer.new()
var on_cooldown := false
signal press(tower_enum: Data.Tower)
@onready var free_label = $TextureRect/Free/FreeLabel
@onready var free_badge = $TextureRect/Free
@onready var cooldown_bar: TextureProgressBar = $cooldown
func setup(new_id: Data.Tower):
	id = new_id
	cost = Data.TOWER_DATA[id]["cost"]

	$TextureRect/TowerName.text = Data.TOWER_DATA[id]["name"]
	$TextureRect/ServerLoad.text = str(Data.TOWER_DATA[id]["server_load"])
	$TextureRect/TowerCost.text = str(cost)
	$TextureRect/TextureRect.texture = load(Data.TOWER_DATA[id]["thumbnail"])
	if id == 0:
		$GPUParticles2D5.show()
func _ready() -> void:
	if not is_in_group("TowerCard"):
		add_to_group("TowerCard")

	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = TOWER_COOLDOWN
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	cooldown_bar.visible = false
	cooldown_bar.value = 0

	Data.server_load_changed.connect(_on_server_load_changed)
	# ensure cost is set even if setup wasn't called before ready
	cost = Data.TOWER_DATA[id]['cost']
	$TextureRect/TowerCost.text = str(cost)
	toggle_active(Data.money)
	update_free_label()
	GameDialogueManager.signal_highlight.connect(toggle_hightlight)

func toggle_hightlight(state: bool):
		$GPUParticles2D5.restart()
		$GPUParticles2D5.emitting = state

func toggle_active(_money := 0):
	if on_cooldown:
		return

	var load = Data.TOWER_DATA[id]["server_load"]
	var has_free = Data.free_towers.get(id, 0) > 0
	var can_buy = Data.is_unli_money or Data.money >= cost
	var can_use = has_free or can_buy
	var can_load = Data.currentserverload + load <= Data.maxserverload
	if not credential_disable_sources.is_empty():
		disabled = true
		return
	if id == Data.Tower.BACKUP_SERVER and Data.backup_server_placed:
		disabled = true
		return
	disabled = !(can_use and can_load)

func set_credential_disabled(source: Node, should_disable: bool) -> void:
	if should_disable:
		if not credential_disable_sources.has(source):
			credential_disable_sources.append(source)
	else:
		credential_disable_sources.erase(source)
	toggle_active(Data.money)

func start_cooldown() -> void:
	if not Data.wave_started:
		return
	on_cooldown = true
	cooldown_bar.visible = true
	cooldown_bar.max_value = TOWER_COOLDOWN
	cooldown_bar.value = TOWER_COOLDOWN
	cooldown_timer.start(TOWER_COOLDOWN)

func _process(_delta: float) -> void:
	if on_cooldown:
		cooldown_bar.value = cooldown_timer.time_left

func _on_cooldown_finished() -> void:
	on_cooldown = false
	cooldown_bar.visible = false
	cooldown_bar.value = 0
	toggle_active(Data.money)

func is_credential_disabled_by(source: Node) -> bool:
	return credential_disable_sources.has(source)
	
func update_free_label():
	var amount = Data.free_towers.get(id, 0)

	free_badge.visible = amount > 0 and not Data.is_sandbox

	if amount > 0:
		free_label.text = str(amount)

func _on_pressed() -> void:
	if on_cooldown:
		return

	UISound.play_click()
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.set_selected(false)

	set_selected(true)
	press.emit(id)
	
func _on_server_load_changed():
	toggle_active(Data.money)

func set_selected(selected: bool) -> void:
	if selected:
		modulate = Color(0.6, 0.6, 0.6, 1.0)
	else:
		modulate = Color.WHITE
