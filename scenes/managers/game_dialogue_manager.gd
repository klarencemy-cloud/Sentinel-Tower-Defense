extends Node
signal show_char()

var is_override: bool = false # check to override what is being shown
var is_introduction_spam_filter: bool = false
var is_defeat_spam: bool = false # check if spam filter is introduced
var is_health_shown: bool = false
var clicked: int = 0


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

func start_wave():
	var ui = get_tree().get_first_node_in_group("UI")
	ui.start_wave.emit()

func move_camera(x: float, y: float):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.move_camera(Vector2(x, y))

func show_dialogue_introduction(): # used in loading
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "start")

func show_dialogue_spam_filter(): # used in tower manager
	pause_game(true)
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_filter")
	is_introduction_spam_filter = true

func show_dialogue_spam_defeat(): # used in wave manager
	pause_game(true)
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_defeat")
	is_defeat_spam = true

# func show_dialogue_server_health(): # used in pop up
# 	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "server_health")
# 	is_health_shown = true
