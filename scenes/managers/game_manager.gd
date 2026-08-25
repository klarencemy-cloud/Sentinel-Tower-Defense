extends Node2D

@onready var level_manager = $LevelManager
@onready var tower_manager = $TowerManager
@onready var ability_manager = $AbilityManager
@onready var wave_manager = $WaveManager
@onready var sentinel_manager = $SentinelManager
@onready var victory_overlay = $UI/VictoryOverlay


func _ready() -> void:
	randomize()
	RenderingServer.set_default_clear_color("242a2f")
	$BG/TowerPreview.hide()
	$BG/SentinelPreview.hide()

	level_manager.setup(self)

	tower_manager.setup(self, level_manager)
	ability_manager.setup(self, level_manager)
	sentinel_manager.setup(self, level_manager)

	tower_manager.restore_saved_towers()

	wave_manager.setup(level_manager.current_map, level_manager)

	wave_manager.level_completed.connect(level_completed)
	wave_manager.next_map.connect(next_map)

	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.place_ability.connect(_on_ui_place_ability)
		ui.spawn_enemy.connect(_on_ui_spawn_sandbox_enemy)

func level_completed() -> void:
	victory_overlay._show_victory_overlay()
	victory_overlay._fade(0.7, 1)
	victory_overlay._fade_victory(1, 1)
	victory_overlay._fade_continue_label(1, 2)


func next_map() -> void:
	Data.current_level_index += 1
	Save.save_game()


func _process(_delta: float) -> void:
	wave_manager.update_wave_state()
	if $BG/TowerPreview/TowerPlacement.get_overlapping_areas():
		Data.is_tower_placeable = false
	if $BG/SentinelPreview/SentinelCollision.get_overlapping_areas():
		Data.is_sentinel_placeable = false

func _input(event: InputEvent) -> void:
	tower_manager.handle_input(event)
	ability_manager.handle_input(event)
	sentinel_manager.handle_input(event)


func _on_ui_place_tower(tower_type: Data.Tower) -> void:
	tower_manager.start_tower_placement(tower_type)

func _on_ui_place_ability(ability: Data.Ability) -> void:
	ability_manager.start_ability_placement(ability)

func _on_ui_place_sentinel(sentinel_type: Data.Sentinel) -> void:
	sentinel_manager.start_sentinel_placement(sentinel_type)

func _on_ui_start_wave() -> void:
	wave_manager.start_wave()


func _on_ui_spawn_sandbox_enemy(enemy_enum: Data.Enemy) -> void:
	wave_manager.spawn_sandbox_enemy(enemy_enum)


func _on_tower_placement_area_exited(area: Area2D) -> void:
	Data.is_tower_placeable = true


func _on_tower_placement_area_entered(area: Area2D) -> void:
	Data.is_tower_placeable = false


func _on_sentinel_collision_area_exited(area: Area2D) -> void:
	Data.is_sentinel_placeable = true

func _on_sentinel_collision_area_entered(area: Area2D) -> void:
	Data.is_sentinel_placeable = false
