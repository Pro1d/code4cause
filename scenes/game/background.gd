class_name Background
extends Node3D

var size_x := 0.3*4096*0.01
var middle_limit :float = 0.0
var near_limit :float = 0.0

@onready var middle_holder : Node3D = $MiddleHolder
@onready var near_holder : Node3D = $NearHolder
@onready var far : Node3D = $Far

func _ready() -> void:
	for x in [middle_holder, near_holder] as Array[Node3D]:
		var source_node : Node3D =  x.get_child(0)
		for j in range(2):
			var new_node : Node3D = source_node.duplicate()
			x.add_child(new_node)
			new_node.global_position.x = source_node.global_position.x + (j+1)*size_x

func _process(_delta: float) -> void:
	var offset_middle := global_position.x * 0.5  
	var offset_near := global_position.x * 0.8
	
	# Ne regarder pas plus bas j'ai honte
	if offset_middle > middle_limit + size_x:
		var source_node : Node3D =  middle_holder.get_child(0)
		source_node.global_position.x += size_x * middle_holder.get_child_count()
		middle_holder.move_child(source_node, middle_holder.get_child_count() - 1)
		middle_limit = offset_middle
	middle_holder.position.x = -offset_middle
	
	if offset_near > near_limit + size_x:
		var source_node : Node3D =  near_holder.get_child(0)
		source_node.global_position.x += size_x * near_holder.get_child_count()
		near_holder.move_child(source_node, near_holder.get_child_count() - 1)
		near_limit = offset_near
	near_holder.position.x = -offset_near
