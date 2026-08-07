extends Node

@onready var click: AudioStreamPlayer = $Click
@onready var uibackground_music: AudioStreamPlayer = $UIBackgroundMusic

func play_click():
	click.play()

func play_bg():
	if !uibackground_music.playing:
		uibackground_music.play()
