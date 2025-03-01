class_name PlacementCell
extends Node3D

@export var highlight_hint: Node3D
@onready var child_scene: Node3D = $Scene

var is_set := false
var is_predrawn := false

var current_tile_scene: PackedScene

func _ready() -> void:
	highlight_hint.visible = false

func highlight(enable:bool) -> void:
	highlight_hint.visible = enable

func predraw(scene: PackedScene) -> void:
	if not is_set and scene != null:
		var child : Node3D = scene.instantiate()
		child_scene.add_child(child)
		current_tile_scene = scene
		is_predrawn = true
		
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
		is_predrawn = false

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

func _process(_delta:float) -> void:
	pass
	#if(is_predrawn):
		#predraw_anim()
	
func predraw_anim() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3(1.2, 1.2, 1.2), 0.2) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.2) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	await tween.finished  # Wait for tween cycle to finish
