extends Node

var _mute := false
@onready var player :AudioStreamPlayer
@onready var _music_bus := AudioServer.get_bus_index(&"Music")

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func toggle_mute() -> void:
	set_mute(not _mute)
	
func set_mute(m: bool) -> void:
	_mute = m
	AudioServer.set_bus_mute(_music_bus, _mute)

func is_mute() -> bool:
	return _mute

func set_volume(level: float) -> void:
	set_mute(false)
	AudioServer.set_bus_volume_db(_music_bus, linear_to_db(level))

func stop_music() -> void:
	player.stop()
