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
	reset()
	
	var shake_magnitude := 0.07 # m
	var shake_duration := 0.1 # s
	var gpos := global_position
	var tween := create_tween()
	tween.tween_interval(randf() * 0.4)
	var shake_offset := Vector3(1, 0, 0).rotated(Vector3.UP, randf() * TAU)
	var shake_count := 8
	for i in range(shake_count):
		var shake_factor := pow(float(i + 1) / shake_count, 2.0)
		var shake := shake_offset * shake_magnitude * shake_factor
		var t := tween.parallel() if i > 0 else tween
		t.tween_property(self, "global_position", gpos + shake, shake_duration) \
			.set_delay(i * shake_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		shake_offset = shake_offset.rotated(Vector3.UP, deg_to_rad(180.0 + randf_range(-20.0, 20.0)))
	tween.parallel().tween_property(self, "global_position:y", -5.0, 1.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(shake_count * shake_duration * .85)
	tween.tween_callback(queue_free)
	
func redraw_child(new_is_set:bool, scene: PackedScene) -> void:
	is_set = new_is_set
	for c:Node in child_scene.get_children():
		c.queue_free()
	
	current_tile_scene = scene
	if(!current_tile_scene):
		return
	var child : Node3D = scene.instantiate()
	
	child_scene.add_child(child)
