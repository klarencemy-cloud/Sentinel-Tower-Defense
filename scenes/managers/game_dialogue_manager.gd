extends Node
signal show_char()

var is_override: bool = false


func show_character(name: String):
	show_char.emit(name)