class_name PlacementCell
extends Node3D

@export var highlight_hint: Node3D

func _ready() -> void:
	highlight_hint.visible = false

func highlight() -> void:
	highlight_hint.visible = true
	
func reset() -> void:
	highlight_hint.visible = false
