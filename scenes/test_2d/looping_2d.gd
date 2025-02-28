extends Node2D


var size := 3000
func _ready() -> void:
	var copy : Node2D = $Elements.duplicate()
	copy.global_position.x = size
	copy.name = "NewName"
	add_child(copy)
	
func _process(_delta: float) -> void:
	if (%Player as Node2D).global_position.x > size:
		(%Player as Node2D).global_position.x -= size
		($Camera2D as Node2D).global_position.x -= size


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("OK")
	for x: Node2D in [$NewName, $Elements]:
		print(x.name)
		var node : StaticBody2D= x.get_child(0)
		(node).modulate = Color("ff83ff")
		(node).set_collision_layer_value(1, true) 
