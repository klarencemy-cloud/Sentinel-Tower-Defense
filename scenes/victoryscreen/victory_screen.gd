extends Control

func _ready() -> void:
	if Data.is_vmmode:
		var map_data: Dictionary = Data.VM_MAP_DATA.get(Data.vmmode_map_number, {})
		var map_name: String = map_data.get("title", "")
		$Label2.text = "Congratulation for finishing %s" % map_name
		$NextLevel/Label.text = "Play Again"

		if Data.vmmode_reward_granted:
			$RewardContainer/GoldGroup/GoldLabel.text = "+%d" % map_data.get("reward_gold", 0)
			$RewardContainer/ServerGroup/ServerLabel.text = "+%d" % map_data.get("reward_server_points", 0)
			$RewardContainer.visible = true
		else:
			$AlreadyCollectedLabel.visible = true
	else:
		$Label2.text = "You've completed level %s!" % Data.current_level_index

func _on_next_level_pressed() -> void:
	UISound.play_click()
	if Data.is_vmmode:
		VMSave.clear_save(Data.vmmode_map_number)
		Data.vmmode_resume_progress = {}
		Data.currentserverload = 0
	get_tree().change_scene_to_file("res://scenes/loading/loading.tscn")


func _on_main_menu_pressed() -> void:
	UISound.play_click()
	if Data.is_vmmode:
		_restore_vmmode_state()
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")


func _restore_vmmode_state() -> void:
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
