class_name PlacementCell
extends Node3D
signal out

@export var highlight_hint: Node3D
@onready var candidate_tile_holder: Node3D = $Candidate
@onready var current_tile_holder: Node3D = $Current
@onready var cube_node: Node3D = $cube

@onready var animations : CellAnimations = %CellAnimations

var has_player := false
var is_set := false
var is_predrawn := false

var placing_tween: Tween
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

func get_candidate_or_null() -> GameTile:
	return (candidate_tile_holder.get_child(0) as GameTile)
	
func get_current_or_null() -> GameTile:
	return (current_tile_holder.get_child(0) as GameTile)
	
func placing_available() -> bool:
	return (not is_set) and (placing_tween == null or (not placing_tween.is_running()))

func highlight(enable:bool) -> void:
	highlight_hint.visible = enable
	cube_node.visible = not enable

func predraw(scene: PackedScene, rad: float = 0.) -> void:
	highlight_hint.visible = true
	if not is_set and scene != null:
		var new_candidate : GameTile = scene.instantiate()
		new_candidate.rotate_y(rad)
		new_candidate.target_rot_y += rad
		candidate_tile_holder.add_child(new_candidate)
		new_candidate.scale = 0.9*Vector3.ONE
		
		is_predrawn = true
		candidate_tile_holder.position.y = normal_placing_elevation
		
func rotate_cell(rad: float) -> void:
	if is_set:
		return
		
	if abs(rad) > 0:
		if rotate_tween != null:
			rotate_tween.kill()
			
		rotate_tween = animations.block_rotation(self, rad)
	
func reset() -> void:
	highlight_hint.visible = false
	
	if(candidate_tile_holder.get_child_count() == 0):
		return
		
	if not is_set:
		candidate_tile_holder.remove_child(get_candidate_or_null())
		is_predrawn = false
		cube_node.visible = true

func place(show_animation: bool = true) -> void:
	cube_node.visible = false
	#Reset animations
	if(predraw_tween):
		predraw_tween.stop()
	if(show_animation):
		is_predrawn = false
		placing_tween = animations.placing_animation(self)
		await placing_tween.finished
	
	is_set = true
	if get_candidate_or_null() == null:
		return 
	get_candidate_or_null().scale = Vector3.ONE
	candidate_tile_holder.position.y = 0.0
	get_candidate_or_null().draw_props()
 
	var paths := get_candidate_or_null().find_children("*", "Path3D") as Array[Node]
	for path in paths:
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
