class_name UIFader
extends Control

@export var fader_color: Color = Color.BLACK
@export var duration: float
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	SceneManager.ui_fader = self

func fade_in() -> void:
	color_rect.color = fader_color
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), duration)
	await tween.finished

func fade_out() -> void:
	color_rect.color = Color(Color.BLACK, 0.0)
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "color", fader_color, duration)
	await tween.finished

func fade_out_hold(time: float) -> void:
	color_rect.color = Color(Color.BLACK, time)

func reset_fade() -> void:
	color_rect.color = Color(Color.BLACK, 0.0)
