class_name PlacementCell
extends Node3D

@export var highlight_hint: Node3D
@onready var child_scene: Node3D = $Scene
var is_set := false

func _ready() -> void:
	highlight_hint.visible = false

func highlight(scene: PackedScene) -> void:
	highlight_hint.visible = true
	if not is_set and scene != null:
		var child : Node3D = scene.instantiate()
		child_scene.add_child(child)
		
func rotate_cell(rad: float) -> void:
	if is_set:
		return
		
	child_scene.rotate_y(rad)
	
func reset() -> void:
	highlight_hint.visible = false
	if not is_set:
		child_scene.remove_child(child_scene.get_child(0))

func place() -> void:
	is_set = true
