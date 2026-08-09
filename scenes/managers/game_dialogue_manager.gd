extends Node
signal show_char()


var is_introduction_shown: bool = false
var is_override: bool = false # check to override what is being shown
var is_introduction_spam_filter: bool = false
var is_defeat_spam: bool = false # check if spam filter is introduced
var is_health_shown: bool = false
var is_wave2_defeated: bool = false
var clicked: int = 0
var is_level_3: bool = true
var is_wave3_defeated: bool = false
var is_prep: bool = false
var is_virus_shown = false
var is_server2: bool = false
var is_server_cyber_shown: bool = false
var is_adware_shown: bool = false
var is_adware_shown2: bool = false
var is_specialist_shown: bool = false
var is_boss1_shown: bool = false
var is_boss1_2_shown: bool = false
var is_boss1_defeated: bool = false

var is_skill_activated: bool = false

var is_level2_start_shown: bool = false

var is_autoplay: bool = true

func show_character(name: String):
	show_char.emit(name)

func pause_game(state: bool):
	get_tree().paused = state

func show_enemy(enemy_name: String, index: int):
	get_tree().paused = true
	var animation = get_tree().get_first_node_in_group("animate")
	var ui = get_tree().get_first_node_in_group("UI")
	ui.trigger_shake()
	animation.play_animation(enemy_name, index)

func show_script(index: int):
	get_tree().paused = true
	var animation = get_tree().get_first_node_in_group("animate2")
	var ui = get_tree().get_first_node_in_group("UI")
	ui.trigger_shake()
	animation.play_animation(index)

func camera_tremor(intensity: float):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.trigger_shell_tremor(intensity)

func camera_shake():
	var ui = get_tree().get_first_node_in_group("UI")
	ui.trigger_shake()

func start_wave():
	get_tree().paused = false
	var ui = get_tree().get_first_node_in_group("UI")
	ui.start_wave.emit()

func move_camera(x: float, y: float, timer: float):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.move_camera(Vector2(x, y))
	await get_tree().create_timer(timer).timeout

func delay_dialogue(time: float):
	await get_tree().create_timer(time).timeout

func penalty(type: String, value: float):
	if type == "money":
		if Data.money > value:
			Data.money -= value
		elif Data.money < value:
			Data.money = 0

func reward(type: String, value: float):
	if type == "money":
		Data.money += value

func _disable_auto() -> void:
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.disable_auto()

func play_scene(scene: String):
	_disable_auto()
	var ui = get_tree().get_first_node_in_group("UI")
	ui.play_scene(scene)
# func show_dialogue_server_health(): # used in pop up
# 	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "server_health")
# 	is_health_shown = true

func show_play():
	var ui = get_tree().get_first_node_in_group("UI")
	ui.show_play_button(true)

func toggle_fade_transition():
	var ui = get_tree().get_first_node_in_group("UI")
	ui.toggle_fade()

func show_dialogue_introduction(): # used in loading
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "start")
	is_introduction_shown = true

func show_dialogue_spam_filter(): # used in tower manager
	_disable_auto()
	pause_game(true)
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_filter")
	is_introduction_spam_filter = true

func show_dialogue_spam_defeat(): # used in wave manager
	_disable_auto()
	pause_game(false)
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_defeat")
	is_defeat_spam = true

func show_dialogue_backstory(): # used in cutscene
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "backstory")

func show_dialogue_wave2_defeat(): # used in cutscene
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "wave2_defeat")
	is_wave2_defeated = true

func show_dialogue_server_upgrade(): # used data
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "server_upgrade")
	is_level_3 = false

func show_dialogue_wave3_defeat(): # used in server_upgrade
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "wave3_defeat")
	is_wave3_defeated = true

func show_dialogue_preparation_end(): # used in tower manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "preparation_end")
	is_prep = true

func show_dialogue_virus(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "virus")
	is_virus_shown = false

var is_firewall_shown: bool = false # used in wave manager
func show_dialogue_firewall():
	_disable_auto()
	var ui = get_tree().get_first_node_in_group("UI")
	ui.toggle_skill_activation()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "firewall")
	is_firewall_shown = true

var is_firewall_activated_shown: bool = false
func show_dialogue_firewall_activated(): # used in ability manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "firewall_activated")
	is_firewall_activated_shown = true

var is_question_1_shown: bool = false
func show_dialogue_question1(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "question1")
	is_question_1_shown = true

func show_dialogue_server_upgrade_2(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "server_upgrade2")
	is_server2 = true

func show_dialogue_server_cyber(): # used in server upgrade
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "server_open_cyber")
	is_server_cyber_shown = true

func show_dialogue_adware(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "adware")
	is_adware_shown = true

func show_dialogue_adware2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "adware2")
	is_adware_shown2 = true

func show_dialogue_specialist():
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "specialist")
	is_specialist_shown = true

func show_dialogue_boss1(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "Boss1")
	is_boss1_shown = true

func show_dialogue_boss1_2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "Boss1_2")
	is_boss1_shown = true

func show_dialogue_boss1_defeated(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "Boss1_defeated")
	is_boss1_defeated = true

var is_boss1_defeated2: bool = false
func show_dialogue_boss1_defeated2(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "Boss1_defeated2")
	is_boss1_defeated2 = true

func show_dialogue_level2_start(): # used in loading
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "start")
	is_level2_start_shown = true

var is_question_2_shown
func show_dialogue_question2(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "question2")
	is_question_2_shown = true

var is_level2_worm_shown: bool = false # used in wave manager
func show_dialogue_level2_worm():
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "worms")
	is_level2_worm_shown = true

var is_level2_worm2_shown: bool = false # used in enemy
func show_dialogue_level2_worm2():
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "worms2")
	is_level2_worm2_shown = true

var is_question_3_shown
func show_dialogue_question3(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "question3")
	is_question_3_shown = true

var is_level2_spyware_shown: bool = false
func show_dialogue_level2_spyware(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "spyware")
	is_level2_spyware_shown = true

var is_level2_spyware2_shown: bool = false
func show_dialogue_level2_spyware2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "spyware2")
	is_level2_spyware2_shown = true

var is_level2_botnet_shown: bool = false
func show_dialogue_level2_botnet(): # used in wave manager
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "botnet")
	is_level2_botnet_shown = true

var is_level2_botnet2_shown: bool = false
func show_dialogue_level2_botnet2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "botnet2")
	is_level2_botnet2_shown = true

var is_level2_boss2_shown: bool = false
func show_dialogue_level2_boss2(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "Boss2")
	is_level2_boss2_shown = true


var is_level2_boss2_2_shown: bool = false
func show_dialogue_level2_boss2_2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "Boss2_2")
	is_level2_boss2_2_shown = true


var is_leve2_boss2_hp_shown: bool = false
func show_dialogue_level2_boss2_hp(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "Boss2_hp")
	is_leve2_boss2_hp_shown = true

var is_level2_boss2_defeated: bool = false
func show_dialogue_level2_boss2_defeated(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "Boss2_defeated")
	is_level2_boss2_defeated = true

var is_level2_boss2_defeated2: bool = false
func show_dialogue_level2_boss2_defeated2(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level2.dialogue"), "Boss2_defeated2")
	is_level2_boss2_defeated2 = true

var is_level3_start_shown: bool = false
func show_dialogue_level3_start(): # used in loading
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "start")
	is_level3_start_shown = true

var is_question_4_shown: bool = false
func show_dialogue_question4(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "question4")
	is_question_4_shown = true

var is_level3_credential_shown: bool = false
func show_dialogue_level3_credential(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "credential_stuffing")
	is_level3_credential_shown = true

var is_level3_credential2_shown: bool = false
func show_dialogue_level3_credential2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "credential_stuffing2")
	is_level3_credential2_shown = true

var is_level3_trojan_horse_shown: bool = false
func show_dialogue_level3_trojan_horse(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "trojan_horse")
	is_level3_trojan_horse_shown = true

var is_level3_trojan_horse2_shown: bool = false
func show_dialogue_level3_trojan2_horse(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "trojan_horse2")
	is_level3_trojan_horse2_shown = true


var is_question_5_shown: bool = false
func show_dialogue_question5(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "question5")
	is_question_5_shown = true

var is_quiz1_shown: bool = false
func show_dialogue_level3_quiz1(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "quiz1")
	is_quiz1_shown = true
 
var is_insider2_shown: bool = false
func show_dialogue_level3_insider2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "insider_threat2")
	is_insider2_shown = true

var is_boss3_shown: bool = false
func show_dialogue_level3_boss3(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "Boss3")
	is_boss3_shown = true

var is_boss3_hp_shown: bool = false
func show_dialogue_level3_boss3_hp(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "Boss3_hp")
	is_boss3_hp_shown = true

var is_boss3_defeated: bool = false
func show_dialogue_level3_boss3_defeated(): # used enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "Boss3_defeated")
	is_boss3_defeated = true

var is_boss3_defeated2: bool = false
func show_dialogue_level3_boss3_defeated2(): # used enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level3.dialogue"), "Boss3_defeated2")
	is_boss3_defeated2 = true


var is_level4_start_shown: bool = false
func show_dialogue_level4_start(): # used loading
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "start")
	is_level4_start_shown = true

var is_question_6_shown: bool = false
func show_dialogue_question6(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "question6")
	is_question_6_shown = true

var is_level4_rootkit_shown: bool = false
func show_dialogue_level4_rootkit(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "rootkit")
	is_level4_rootkit_shown = true

var is_level4_sql_shown: bool = false
func show_dialogue_level4_sql(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "sql")
	is_level4_sql_shown = true

var is_level4_quiz2_shown: bool = false
func show_dialogue_level4_quiz2(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "quiz2")
	is_level4_quiz2_shown = true

var is_level4_ddos_shown: bool = false
func show_dialogue_level4_ddos(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "ddos")
	is_level4_ddos_shown = true

var is_question_7_shown: bool = false
func show_dialogue_question7(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "question7")
	is_question_7_shown = true

var is_strange_discovery_shown: bool = false
func show_dialogue_level4_strange_discovery(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "strange_discovery")
	is_strange_discovery_shown = true

var is_level4_ransomware_shown: bool = false
func show_dialogue_level4_ransomware(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "ransomware")
	is_level4_ransomware_shown = true

var is_level4_ransomware2_shown: bool = false
func show_dialogue_level4_ransomware2(): # used popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "ransomware2")
	is_level4_ransomware2_shown = true


var is_boss4_shown: bool = false
func show_dialogue_level4_boss4(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "Boss4")
	is_boss4_shown = true

var is_boss4_shown2: bool = false
func show_dialogue_level4_boss4_2(): # used popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "Boss4_2")
	is_boss4_shown2 = true

var is_boss4_hp_shown: bool = false
func show_dialogue_level4_boss4_hp(): # used enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "Boss4_hp")
	is_boss4_hp_shown = true

var is_boss4_defeated_shown: bool = false
func show_dialogue_level4_boss4_defeated(): # used enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "Boss4_defeated")
	is_boss4_defeated_shown = true

var is_boss4_defeated_shown2: bool = false
func show_dialogue_level4_boss4_defeated2(): # used enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level4.dialogue"), "Boss4_defeated2")
	is_boss4_defeated_shown2 = true

var is_level5_start_shown: bool = false
func show_dialogue_level5_start(): # used loading
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "start")
	is_level5_start_shown = true

var is_zero_day_shown: bool = false
func show_dialogue_level5_zero_day(): # used wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "zero_day")
	is_zero_day_shown = true

var is_zero_day_shown2: bool = false
func show_dialogue_level5_zero_day2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "zero_day2")
	is_zero_day_shown2 = true

var is_question_8_shown: bool = false
func show_dialogue_question8(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "question8")
	is_question_8_shown = true

var is_level5_quiz3_shown: bool = false
func show_dialogue_level5_quiz3(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "quiz3")
	is_level5_quiz3_shown = true

var is_question_9_shown: bool = false
func show_dialogue_question9(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "question9")
	is_question_9_shown = true

var is_level5_hidden_archive_shown: bool = false
func show_dialogue_level5_hidden_archive(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "hidden_archive")
	is_level5_hidden_archive_shown = true

var is_level5_hidden_archive2_shown: bool = false
func show_dialogue_level5_hidden_archive2(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "hidden_archive2")
	is_level5_hidden_archive2_shown = true

var is_level5_final_fragment_shown: bool = false
func show_dialogue_level5_final_fragment(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "final_fragment")
	is_level5_final_fragment_shown = true

var is_level5_boss5_shown: bool = false
func show_dialogue_level5_boss5(): # used in wave manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss5")
	is_level5_boss5_shown = true

var is_level5_boss5_shown2: bool = false
func show_dialogue_level5_boss5_2(): # used in popup
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss5_2")
	is_level5_boss5_shown2 = true

var is_level5_boss5_hp_shown: bool = false
func show_dialogue_level5_boss5_hp(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss5_hp")
	is_level5_boss5_hp_shown = true


var is_level5_boss5_defeated_shown: bool = false
func show_dialogue_level5_boss5_defeated(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss5_defeated")
	is_level5_boss5_defeated_shown = true

var is_level6_boss6_shown: bool = false
func show_dialogue_level6_boss6(): # used in wave_manager
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss6")
	is_level6_boss6_shown = true


var is_level6_boss6_hp_shown: bool = false
func show_dialogue_level6_boss6_hp(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss6_hp")
	is_level6_boss6_hp_shown = true

var is_level6_boss6_defeated_shown: bool = false
func show_dialogue_level6_boss6_defeated(): # used in enemy
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "Boss6_defeated")
	is_level6_boss6_defeated_shown = true


var is_story_ends: bool = false
func show_dialogue_story_ends(): # used in scripture
	_disable_auto()
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/Level5.dialogue"), "ending")
	is_story_ends = true
