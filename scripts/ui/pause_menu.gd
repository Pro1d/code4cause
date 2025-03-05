class_name PauseMenu
extends Node

func set_music_volume(value:float) -> void:
	MusicManager.set_volume(value)

func set_sfx_volume(value:float) -> void:
	SoundFxManager.set_volume(value)
