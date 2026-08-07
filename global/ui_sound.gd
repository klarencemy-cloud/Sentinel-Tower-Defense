extends Node

@onready var click: AudioStreamPlayer = $Click
@onready var uibackground_music: AudioStreamPlayer = $UIBackgroundMusic

func play_click():
	click.play()

func play_bg():
	if !uibackground_music.playing:
		await get_tree().create_timer(0.5).timeout
		
		var target_volume = uibackground_music.volume_db
		uibackground_music.volume_db = -80.0 
		uibackground_music.play()
		
		var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(uibackground_music, "volume_db", target_volume, 2.0)
