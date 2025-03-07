extends Node

@onready var ui_sound := AudioStreamPlayer.new()
@onready var _sfx_bus := AudioServer.get_bus_index(&"SoundFx")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_sound.bus = &"SoundFX"
	#ui_sound.stream = preload("res://assets/sounds/tuck.ogg")
	add_child(ui_sound)

func keep_until_finished(audio: Node) -> void: # AudioStreamPlayer[2D]
	audio.get_parent().remove_child(audio)
	add_child(audio)
	
	var asp := audio as AudioStreamPlayer
	if asp != null:
		asp.finished.connect(audio.queue_free)
		return
	var asp2d := audio as AudioStreamPlayer2D
	if asp2d != null:
		asp2d.finished.connect(audio.queue_free)
		return
	var asp3d := audio as AudioStreamPlayer3D
	if asp3d != null:
		asp3d.finished.connect(audio.queue_free)
		return

func set_volume(level: float) -> void:
	AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(level))
	
func keep_audio_3d_until_finished(audio: AudioStreamPlayer3D) -> void:
	var t := audio.global_transform
	
	# reparent
	audio.get_parent().remove_child(audio)
	add_child(audio)
	
	# keep transform
	audio.top_level = true
	audio.global_transform = t
	
	# later free
	audio.finished.connect(audio.queue_free)

func connect_all_buttons(node: Node) -> void:
	if node is Button:
		connect_button(node as Button)
	if node is OptionButton:
		connect_option_button(node as OptionButton)
	for c in node.get_children():
		connect_all_buttons(c)

func connect_button(button: Button) -> void:
	button.pressed.connect(ui_sound.play)

func connect_option_button(button: OptionButton) -> void:
	button.item_selected.connect(ui_sound.play)
