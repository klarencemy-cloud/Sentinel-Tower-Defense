extends Node

@onready var click_open: AudioStreamPlayer = $ClickOpen
@onready var click_close: AudioStreamPlayer = $ClickClose
@onready var click_carousel: AudioStreamPlayer = $ClickCarousel
@onready var uibackground_music: AudioStreamPlayer = $UIBackgroundMusic
@onready var game_background_music: AudioStreamPlayer = $GameBackgroundMusic
@onready var dialogue_typing: AudioStreamPlayer = $DialogueTyping
@onready var click_unlock: AudioStreamPlayer = $ClickUnlock
@onready var air_background: AudioStreamPlayer = $AirBackground
@onready var rain_background: AudioStreamPlayer = $RainBackground
@onready var emergency: AudioStreamPlayer = $Emergency
@onready var boss_battle_background_music: AudioStreamPlayer = $BossBattleBackgroundMusic

var _ui_bg_tween: Tween
var _game_bg_tween: Tween
var _air_bg_tween: Tween
var _rain_bg_tween: Tween
var _emergency_tween: Tween
var _boss_bg_tween: Tween
var _ui_bg_volume: float
var _game_bg_volume: float
var _air_bg_volume: float
var _rain_bg_volume: float
var _emergency_volume: float
var _boss_bg_volume: float
var _emergency_looping: bool = false
const EMERGENCY_LOOP := false

func _ready():
	_ui_bg_volume = uibackground_music.volume_db
	_game_bg_volume = game_background_music.volume_db
	_air_bg_volume = air_background.volume_db
	_rain_bg_volume = rain_background.volume_db
	_emergency_volume = emergency.volume_db
	_boss_bg_volume = boss_battle_background_music.volume_db
	emergency.finished.connect(_on_emergency_finished)

func play_click():
	click_open.play()

func play_close():
	click_close.play()

func play_carousel():
	click_carousel.play()

func play_unlock():
	click_unlock.play()

func play_emergency():
	_kill_tween(_emergency_tween)
	_emergency_looping = EMERGENCY_LOOP
	emergency.volume_db = _emergency_volume
	if !emergency.playing:
		emergency.play()

func _on_emergency_finished():
	if _emergency_looping:
		emergency.play()

func stop_emergency(fade: float = 1.0):
	_emergency_looping = false
	_kill_tween(_emergency_tween)
	if !emergency.playing:
		emergency.volume_db = _emergency_volume
		return

	_emergency_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_emergency_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_emergency_tween.tween_property(emergency, "volume_db", -80.0, fade)
	await _emergency_tween.finished
	emergency.stop()
	emergency.volume_db = _emergency_volume

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
		if is_equal_approx(game_background_music.volume_db, _game_bg_volume):
			return
		_game_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_game_bg_tween.tween_property(game_background_music, "volume_db", _game_bg_volume, 2.0)
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


func play_boss_bg(fade: float = 0.0):
	_kill_tween(_boss_bg_tween)
	stop_game_bg()
	if boss_battle_background_music.playing:
		return

	if fade <= 0.0:
		boss_battle_background_music.volume_db = _boss_bg_volume
		boss_battle_background_music.play()
		return

	boss_battle_background_music.volume_db = -80.0
	boss_battle_background_music.play()

	_boss_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_boss_bg_tween.tween_property(boss_battle_background_music, "volume_db", _boss_bg_volume, fade)


func stop_boss_bg(resume_game_bg: bool = true):
	_kill_tween(_boss_bg_tween)
	if !boss_battle_background_music.playing:
		if resume_game_bg:
			play_game_bg()
		return

	_boss_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_boss_bg_tween.tween_property(boss_battle_background_music, "volume_db", -80.0, 2.0)
	await _boss_bg_tween.finished
	boss_battle_background_music.stop()
	boss_battle_background_music.volume_db = _boss_bg_volume
	if resume_game_bg:
		play_game_bg()


func play_air_bg():
	_kill_tween(_air_bg_tween)
	if air_background.playing:
		return

	air_background.volume_db = -80.0
	air_background.play()

	_air_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_air_bg_tween.tween_property(air_background, "volume_db", _air_bg_volume, 2.0)

func stop_air_bg():
	_kill_tween(_air_bg_tween)
	if !air_background.playing:
		return

	_air_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_air_bg_tween.tween_property(air_background, "volume_db", -80.0, 2.0)
	await _air_bg_tween.finished
	air_background.stop()
	air_background.volume_db = _air_bg_volume

func play_rain_bg():
	_kill_tween(_rain_bg_tween)
	if rain_background.playing:
		return

	rain_background.volume_db = -80.0
	rain_background.play()

	_rain_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_rain_bg_tween.tween_property(rain_background, "volume_db", _rain_bg_volume, 2.0)

func stop_rain_bg():
	_kill_tween(_rain_bg_tween)
	if !rain_background.playing:
		return

	_rain_bg_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_rain_bg_tween.tween_property(rain_background, "volume_db", -80.0, 2.0)
	await _rain_bg_tween.finished
	rain_background.stop()
	rain_background.volume_db = _rain_bg_volume

func _kill_tween(tween: Tween):
	if tween and tween.is_valid():
		tween.kill()