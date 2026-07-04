extends Node
signal show_char()

var is_override: bool = false # check to override what is being shown
var is_introduction_spam_filter: bool = false
var is_defeat_spam: bool = false # check if spam filter is introduced


func show_character(name: String):
	show_char.emit(name)


func show_dialogue_introduction(): # used in loading
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "start")

func show_dialogue_spam_filter(): # used in tower manager
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_filter")
	is_introduction_spam_filter = true

func show_dialogue_spam_defeat(): # used in wave manager
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/introduction.dialogue"), "spam_defeat")
	is_defeat_spam = true


func show_enemy():
	var animation = get_tree().get_first_node_in_group("animate")
	var ui = get_tree().get_first_node_in_group("UI")
	ui.trigger_shake()
	animation.play_animation()