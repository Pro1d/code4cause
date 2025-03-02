class_name Bomb
extends Node3D

var is_lit := false
var base_position: Vector3

func lit_up() -> void:
	is_lit = true
	base_position = position
	
func explode() -> void:
	if(!is_lit):
		return
	print("bomb exploded")

func _process(delta: float) -> void:
	if(is_lit):
		position = base_position + (Vector3.UP * sin(delta * 100.0) * 5.0)
