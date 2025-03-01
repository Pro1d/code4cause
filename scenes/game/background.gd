class_name Background
extends Node3D

var size_x := 500
var offset_x : float = 0.0

@onready var middle_holder : Node3D = $MiddleHolder
@onready var near_holder : Node3D = $NearHolder


@onready var far : Node3D = $Far

func _ready() -> void:
	for x in [middle_holder, near_holder] as Array[Node3D]:
		var new_node : Node3D = x.get_child(0).duplicate()
		x.add_child(new_node)
		new_node.global_position.x += size_x

func _process(_delta: float) -> void:
	var node : Sprite3D = middle_holder.get_child(0)
	prints(node.global_position, node.global_rotation)
	prints(far.global_position, far.global_rotation)
	print("--")
	
	far.global_position.x = offset_x
