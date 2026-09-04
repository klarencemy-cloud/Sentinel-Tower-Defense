extends CanvasLayer

@onready var master_slider: HSlider = $Panel/MasterSlider
@onready var sound_slider: HSlider = $Panel/SoundSlider
@onready var music_slider: HSlider = $Panel/MusicSlider

@onready var master_icon: TextureButton = $Panel/MasterIcon
@onready var sound_icon: TextureButton = $Panel/SoundIcon
@onready var music_icon: TextureButton = $Panel/MusicIcon

@onready var master_slash: Line2D = $Panel/MasterIcon/Slash
@onready var sound_slash: Line2D = $Panel/SoundIcon/Slash
@onready var music_slash: Line2D = $Panel/MusicIcon/Slash

@onready var cancel_button: Button = $Panel/CancelButton
@onready var save_button: Button = $Panel/SaveButton

var _pending_master_volume: float
var _pending_sound_volume: float
var _pending_music_volume: float
var _pending_master_muted: bool
var _pending_sound_muted: bool
var _pending_music_muted: bool


func _ready() -> void:
	visible = false

	master_slider.value_changed.connect(_on_master_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)

	master_icon.toggled.connect(_on_master_icon_toggled)
	sound_icon.toggled.connect(_on_sound_icon_toggled)
	music_icon.toggled.connect(_on_music_icon_toggled)

	cancel_button.pressed.connect(_on_cancel_pressed)
	save_button.pressed.connect(_on_save_pressed)


func open() -> void:
	_pending_master_volume = Settings.master_volume
	_pending_sound_volume = Settings.sound_volume
	_pending_music_volume = Settings.music_volume
	_pending_master_muted = Settings.master_muted
	_pending_sound_muted = Settings.sound_muted
	_pending_music_muted = Settings.music_muted

	master_slider.set_value_no_signal(_pending_master_volume)
	sound_slider.set_value_no_signal(_pending_sound_volume)
	music_slider.set_value_no_signal(_pending_music_volume)

	master_icon.set_pressed_no_signal(_pending_master_muted)
	sound_icon.set_pressed_no_signal(_pending_sound_muted)
	music_icon.set_pressed_no_signal(_pending_music_muted)

	master_slash.visible = _pending_master_muted
	sound_slash.visible = _pending_sound_muted
	music_slash.visible = _pending_music_muted

	visible = true
	UISound.play_click()


func _on_master_slider_changed(value: float) -> void:
	_pending_master_volume = value
	Settings.apply_live_master(_pending_master_volume, _pending_master_muted)


func _on_sound_slider_changed(value: float) -> void:
	_pending_sound_volume = value
	Settings.apply_live_sound(_pending_sound_volume, _pending_sound_muted)


func _on_music_slider_changed(value: float) -> void:
	_pending_music_volume = value
	Settings.apply_live_music(_pending_music_volume, _pending_music_muted)


func _on_master_icon_toggled(pressed: bool) -> void:
	UISound.play_click()
	_pending_master_muted = pressed
	master_slash.visible = pressed
	Settings.apply_live_master(_pending_master_volume, _pending_master_muted)


func _on_sound_icon_toggled(pressed: bool) -> void:
	UISound.play_click()
	_pending_sound_muted = pressed
	sound_slash.visible = pressed
	Settings.apply_live_sound(_pending_sound_volume, _pending_sound_muted)


func _on_music_icon_toggled(pressed: bool) -> void:
	UISound.play_click()
	_pending_music_muted = pressed
	music_slash.visible = pressed
	Settings.apply_live_music(_pending_music_volume, _pending_music_muted)


func _on_save_pressed() -> void:
	Settings.set_master_volume(_pending_master_volume)
	Settings.set_master_muted(_pending_master_muted)
	Settings.set_sound_volume(_pending_sound_volume)
	Settings.set_sound_muted(_pending_sound_muted)
	Settings.set_music_volume(_pending_music_volume)
	Settings.set_music_muted(_pending_music_muted)
	visible = false
	UISound.play_click()


func _on_cancel_pressed() -> void:
	Settings.reapply_saved()
	visible = false
	UISound.play_close()
