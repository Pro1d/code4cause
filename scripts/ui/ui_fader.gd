class_name UIFader
extends Control

@export var fader_color: Color = Color.BLACK
@onready var color_rect: ColorRect = $ColorRect

func fade_in() -> void:
	color_rect.color = fader_color
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "modulate.a", 0.0, 1.0)

func fade_out() -> void:
	color_rect.color = Color(Color.BLACK, 0.0)
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "modulate.a", 1.0, 1.0)
