extends Node

@onready var click_open: AudioStreamPlayer = $ClickOpen
@onready var click_close: AudioStreamPlayer = $ClickClose
@onready var click_carousel: AudioStreamPlayer = $ClickCarousel
@onready var uibackground_music: AudioStreamPlayer = $UIBackgroundMusic
@onready var game_background_music: AudioStreamPlayer = $GameBackgroundMusic
@onready var dialogue_typing: AudioStreamPlayer = $DialogueTyping

var _ui_bg_tween: Tween
var _game_bg_tween: Tween
var _ui_bg_volume: float
var _game_bg_volume: float

func _ready():
	_ui_bg_volume = uibackground_music.volume_db
	_game_bg_volume = game_background_music.volume_db

func play_click():
	click_open.play()

func play_close():
	click_close.play()

func play_carousel():
	click_carousel.play()

func play_dialogue_typing():
	dialogue_typing.play()

func stop_dialogue_typing():
	dialogue_typing.stop()

# UI BG Music
func play_bg():
	_kill_tween(_ui_bg_tween)
	if uibackground_music.playing:
		return
	
	await get_tree().create_timer(0.5).timeout
	uibackground_music.volume_db = -80.0
	uibackground_music.play()
	
	_ui_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_ui_bg_tween.tween_property(uibackground_music, "volume_db", _ui_bg_volume, 2.0)

func stop_bg():
	_kill_tween(_ui_bg_tween)
	if !uibackground_music.playing:
		return
	
	_ui_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_ui_bg_tween.tween_property(uibackground_music, "volume_db", -80.0, 2.0)
	await _ui_bg_tween.finished
	uibackground_music.stop()
	uibackground_music.volume_db = _ui_bg_volume  # restore for next play

# In game BG Music

func play_game_bg():
	_kill_tween(_game_bg_tween)
	if game_background_music.playing:
		return
	
	await get_tree().create_timer(0.5).timeout
	game_background_music.volume_db = -80.0
	game_background_music.play()
	
	_game_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_game_bg_tween.tween_property(game_background_music, "volume_db", _game_bg_volume, 2.0)

func stop_game_bg():
	_kill_tween(_game_bg_tween)
	if !game_background_music.playing:
		return
	
	_game_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_game_bg_tween.tween_property(game_background_music, "volume_db", -80.0, 2.0)
	await _game_bg_tween.finished
	game_background_music.stop()
	game_background_music.volume_db = _game_bg_volume  # restore for next play

func _kill_tween(tween: Tween):
	if tween and tween.is_valid():
		tween.kill()