extends Node

@export var bpm: float = 120.0
@export var bar: int = 4

@export var sfx_on: bool = true
@export var beat_sfx: AudioStream
@export var bar_sfx: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal on_pulse
signal on_bar_start

var pulse_count: int = 0
var first_beat: bool = true
var is_bar: bool = false

@onready var beat_timer: Timer = $Timer

func _ready() -> void:
	beat_timer.wait_time = 60.0 / bpm
	start()

func start() -> void:
	beat_timer.start()
	
func on_timeout() -> void:
	on_pulse.emit()
	is_bar = false
	
	if(pulse_count == 0 and not first_beat):
		on_bar_start.emit()
		is_bar = true
		
	first_beat = false
	pulse_count = (pulse_count + 1) % bar
	play_sfx()
	
func play_sfx() -> void:
	if(!sfx_on):
		return
	if(is_bar):
		audio_stream_player.stream = bar_sfx
		audio_stream_player.play()
	else:
		audio_stream_player.stream = beat_sfx
		audio_stream_player.play()
	
func pause() -> void:
	pass
