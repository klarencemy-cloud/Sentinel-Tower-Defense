extends Node

const SETTINGS_PATH := "user://settings.cfg"

var master_volume: float = 1.0
var sound_volume: float = 1.0
var music_volume: float = 1.0
var master_muted: bool = false
var sound_muted: bool = false
var music_muted: bool = false

var _master_bus_idx: int
var _sound_bus_idx: int
var _music_bus_idx: int


func _ready() -> void:
	_master_bus_idx = AudioServer.get_bus_index("Master")
	_sound_bus_idx = AudioServer.get_bus_index("Sounds")
	_music_bus_idx = AudioServer.get_bus_index("Music")
	_load_settings()
	_apply_all()


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_bus(_master_bus_idx, master_volume, master_muted)
	_save_settings()


func set_sound_volume(value: float) -> void:
	sound_volume = clampf(value, 0.0, 1.0)
	_apply_bus(_sound_bus_idx, sound_volume, sound_muted)
	_save_settings()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_apply_bus(_music_bus_idx, music_volume, music_muted)
	_save_settings()


func set_master_muted(muted: bool) -> void:
	master_muted = muted
	_apply_bus(_master_bus_idx, master_volume, master_muted)
	_save_settings()


func set_sound_muted(muted: bool) -> void:
	sound_muted = muted
	_apply_bus(_sound_bus_idx, sound_volume, sound_muted)
	_save_settings()


func set_music_muted(muted: bool) -> void:
	music_muted = muted
	_apply_bus(_music_bus_idx, music_volume, music_muted)
	_save_settings()


func apply_live_master(volume: float, muted: bool) -> void:
	_apply_bus(_master_bus_idx, volume, muted)


func apply_live_sound(volume: float, muted: bool) -> void:
	_apply_bus(_sound_bus_idx, volume, muted)


func apply_live_music(volume: float, muted: bool) -> void:
	_apply_bus(_music_bus_idx, volume, muted)


func reapply_saved() -> void:
	_apply_all()


func _apply_bus(bus_idx: int, volume: float, muted: bool) -> void:
	if bus_idx < 0:
		return
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(maxf(volume, 0.0001)))
	AudioServer.set_bus_mute(bus_idx, muted)


func _apply_all() -> void:
	_apply_bus(_master_bus_idx, master_volume, master_muted)
	_apply_bus(_sound_bus_idx, sound_volume, sound_muted)
	_apply_bus(_music_bus_idx, music_volume, music_muted)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "master_muted", master_muted)
	config.set_value("audio", "sound_muted", sound_muted)
	config.set_value("audio", "music_muted", music_muted)
	config.save(SETTINGS_PATH)


func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	master_volume = float(config.get_value("audio", "master_volume", master_volume))
	sound_volume = float(config.get_value("audio", "sound_volume", sound_volume))
	music_volume = float(config.get_value("audio", "music_volume", music_volume))
	master_muted = bool(config.get_value("audio", "master_muted", master_muted))
	sound_muted = bool(config.get_value("audio", "sound_muted", sound_muted))
	music_muted = bool(config.get_value("audio", "music_muted", music_muted))
