class_name PlacementCell
extends Node3D
signal out

@export var highlight_hint: Node3D
@onready var child_scene: Node3D = $Scene
@onready var cube_node: Node3D = $cube

@onready var animations : CellAnimations = %CellAnimations

var is_set := false
var is_predrawn := false

var current_tile_scene: PackedScene
var predraw_tween: Tween
var rotate_tween: Tween

var normal_placing_elevation := 0.15
var replacing_elevation := 0.30
var on_player_elevation := 0.60


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
		child.scale = 0.9*Vector3.ONE
		current_tile_scene = scene
		is_predrawn = true
		child_scene.position.y = normal_placing_elevation
		
func rotate_cell(rad: float) -> void:
	if is_set:
		return
		
	if abs(rad) > 0:
		if rotate_tween != null:
			rotate_tween.kill()
			
		rotate_tween = animations.block_rotation(self, rad)
	
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
	
	#Reset animations
	if(predraw_tween):
		predraw_tween.stop()
	(child_scene.get_child(0) as Node3D).scale = Vector3.ONE
	child_scene.position.y = 0.0
	cube_node.visible = false
	
	(child_scene.get_child(0) as GameTile).draw_props()
 
	var path : Path3D = child_scene.get_child(0).get_node_or_null("Path3D")
	if path != null: 
		path.add_to_group(Config.PATH_GROUP)
	
func delete() -> void:
	is_set = false 
	
	var tween := animations.shake_and_fell(self)
	tween.tween_callback(out.emit)
	tween.tween_interval(0.5)
	tween.tween_callback(queue_free)
	
func predraw_anim() -> void:
	if is_predrawn:
		predraw_tween = animations.size_blink(self)
