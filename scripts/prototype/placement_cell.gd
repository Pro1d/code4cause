class_name PlacementCell
extends Node3D

@export var highlight_hint: Node3D
@onready var child_scene: Node3D = $Scene
@onready var cube_node: Node3D = $cube

var is_set := false
var is_predrawn := false

var current_tile_scene: PackedScene
var predraw_tween: Tween
var rotate_tween: Tween

func _ready() -> void: 
	highlight_hint.visible = false
	
func appear() -> void:
	scale = Vector3.ZERO
	var appear_tween := create_tween()
	var appear_duration := 0.5
	appear_tween \
		.tween_property(self, "scale", Vector3.ONE, appear_duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD )

func highlight(enable:bool) -> void:
	highlight_hint.visible = enable
	cube_node.visible = not enable

func predraw(scene: PackedScene, rad: float = 0.) -> void:
	highlight_hint.visible = true
	if not is_set and scene != null:
		var child : GameTile = scene.instantiate()
		child.rotate_y(rad)
		child.target_rot_y += rad
		child_scene.add_child(child)
		current_tile_scene = scene
		is_predrawn = true
		
func rotate_cell(rad: float) -> void:
	if is_set:
		return
		
	if abs(rad) > 0:
		var tile_scene := (child_scene.get_child(0) as GameTile)
		var duration := 0.3
		
		if rotate_tween != null:
			rotate_tween.kill()
			
		tile_scene.target_rot_y += rad  
		var current_angle := tile_scene.rotation.y
		var target_angle := tile_scene.target_rot_y
		target_angle = current_angle + angle_difference(current_angle, target_angle)
		rotate_tween = create_tween()
		rotate_tween \
			.tween_property(tile_scene, "rotation:y", target_angle, duration) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_QUAD )
		rotate_tween \
			.parallel() \
			.tween_property(tile_scene, "scale", 0.7*Vector3.ONE, duration/2)
		rotate_tween.tween_property(tile_scene, "scale", Vector3.ONE, duration/2)
	
func reset() -> void:
	highlight_hint.visible = false
	
	if(child_scene.get_children().size() == 0):
		return
		
		
	if not is_set:
		child_scene.remove_child(child_scene.get_child(0))
		is_predrawn = false
		cube_node.visible = true

func place() -> void:
	is_set = true
	
	if(predraw_tween):
		predraw_tween.stop()
		(child_scene.get_child(0) as Node3D).scale = Vector3.ONE
		
	cube_node.visible = false
	
	(child_scene.get_child(0) as GameTile).draw_props()

	var path : Path3D = child_scene.get_child(0).get_node_or_null("Path3D")
	if path != null: 
		path.add_to_group(Config.PATH_GROUP)
	else:
		print("Error, tile with null path")
	
func delete() -> void:
	is_set = false 
	
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
	
func predraw_anim() -> void:
	if is_predrawn:
		var child: Node3D = child_scene.get_child(0)
		predraw_tween = create_tween()
		predraw_tween.tween_property(child, "scale", Vector3(0.9, 0.9, 0.9), 0.1) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_OUT) 
		predraw_tween.tween_property(child, "scale", Vector3(1.0, 1.0, 1.0), 0.1) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_IN)
