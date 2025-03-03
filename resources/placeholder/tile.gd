class_name GameTile
extends Node3D

class Data:
	var scene : PackedScene
	var orientation : int # range 0-3
	func angle() -> float:
		return orientation * PI / 2

var target_rot_y : float = 0.0

func draw_props() -> void:
	var propFront : int = randi_range(-1, len($Props/Front.get_children())-1)
	if propFront >=0:
		($Props/Front.get_child(propFront) as Node3D).visible = true

	var propBack : int = randi_range(-1, len($Props/Back.get_children())-1)
	if propBack >=0:
		($Props/Back.get_child(propBack) as Node3D).visible = true
