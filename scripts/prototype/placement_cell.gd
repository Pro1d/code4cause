class_name PlacementCell
extends Node3D

@export var highlight_hint: Node3D
@onready var child_scene: Node3D = $Scene
var is_set := false

var current_tile_scene: PackedScene

func _ready() -> void:
	highlight_hint.visible = false

func highlight(scene: PackedScene) -> void:
	highlight_hint.visible = true
	if not is_set and scene != null:
		var child : Node3D = scene.instantiate()
		child_scene.add_child(child)
		current_tile_scene = scene
		
func rotate_cell(rad: float) -> void:
	if is_set:
		return
		
	child_scene.rotate_y(rad)
	
func reset() -> void:
	highlight_hint.visible = false
	
	if(child_scene.get_children().size() == 0):
		return
		
	if not is_set:
		child_scene.remove_child(child_scene.get_child(0))

func place() -> void:
	is_set = true
	
func delete() -> void:
	is_set = false
	var tween := create_tween()
	tween.tween_interval(0.1 - global_position.z/3)
	tween.tween_property(self, "global_position:y", -30.0, 1.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(queue_free)
	reset()
	
func redraw_child(new_is_set:bool, scene: PackedScene) -> void:
	is_set = new_is_set
	for c:Node in child_scene.get_children():
		c.queue_free()
	
	current_tile_scene = scene
	if(!current_tile_scene):
		return
	var child : Node3D = scene.instantiate()
	
	child_scene.add_child(child)
