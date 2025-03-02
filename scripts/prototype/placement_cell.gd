class_name PlacementCell
extends Node3D
signal out

@export var highlight_hint: Node3D
@onready var candidate_tile_holder: Node3D = $CandidateTile
@onready var current_tile_holder: Node3D = $CurrentTile
@onready var cube_node: Node3D = $cube

@onready var animations : CellAnimations = %CellAnimations

var has_player := false : set = set_has_player
var is_set := false
var is_predrawn := false

var placing_tween: Tween
var predraw_tween: Tween
var rotate_tween: Tween

var normal_placing_elevation := 0.15
var replacing_elevation := 0.45
var on_player_elevation := 0.80

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

func set_has_player(s: bool) -> void:
	has_player = s
	if s and get_candidate_or_null() != null:
		candidate_tile_holder.position.y = on_player_elevation
	elif (not s) and get_candidate_or_null() != null:
		candidate_tile_holder.position.y = normal_placing_elevation

func predraw(scene: PackedScene, rad: float = 0.) -> void:
	highlight_hint.visible = true
	if placing_available() and scene != null:
		var new_candidate : GameTile = scene.instantiate()
		new_candidate.rotate_y(rad)
		new_candidate.target_rot_y += rad
		candidate_tile_holder.add_child(new_candidate)
		new_candidate.scale = 0.9*Vector3.ONE
		
		is_predrawn = true
		if has_player:
			candidate_tile_holder.position.y = on_player_elevation
		elif get_current_or_null() != null:
			candidate_tile_holder.position.y = replacing_elevation
		else:
			candidate_tile_holder.position.y = normal_placing_elevation
		
func rotate_cell(rad: float) -> void:
	if not placing_available():
		return
		
	if abs(rad) > 0:
		if rotate_tween != null:
			rotate_tween.kill()
			
		rotate_tween = animations.block_rotation(self, rad)
	
func reset() -> void:
	highlight_hint.visible = false
	
	if(candidate_tile_holder.get_child_count() == 0):
		return
		
	candidate_tile_holder.remove_child(get_candidate_or_null())
	is_predrawn = false
	cube_node.visible = true

func place(show_animation: bool = true) -> bool:
	if has_player:
		return false
	
	cube_node.visible = false
	#Reset animations
	if(predraw_tween):
		predraw_tween.stop()
	if(show_animation):
		Config.controls_available = false
		is_predrawn = false
		
		if get_current_or_null() != null:
			var path_current := get_current_or_null().get_node_or_null("Path3D")
			if path_current != null: 
				path_current.remove_from_group(Config.PATH_GROUP)
			var tween := animations.shake_and_fell(get_current_or_null(), 2)
			tween.tween_callback(get_current_or_null().queue_free)
			await tween.finished
		
		placing_tween = animations.placing_animation(self)
		await placing_tween.finished
		
		Config.controls_available = true 
	
	var candidate :=  get_candidate_or_null()
	if candidate == null:
		print("Weird no candidate")
		return false
		
	candidate_tile_holder.position.y = 0.0 
	candidate.scale = Vector3.ONE
	candidate.reparent(current_tile_holder)
	candidate.draw_props()
 
	var paths := candidate.find_children("*", "Path3D") as Array[Node]
	for path in paths:
		path.add_to_group(Config.PATH_GROUP)
	return true
	
func delete() -> void:	
	var tween := animations.shake_and_fell(self)
	tween.tween_callback(out.emit)
	tween.tween_interval(0.5)
	tween.tween_callback(queue_free)
	
func predraw_anim() -> void:
	if is_predrawn:
		predraw_tween = animations.size_blink(self)
