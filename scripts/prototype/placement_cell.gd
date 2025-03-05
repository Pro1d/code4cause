class_name PlacementCell
extends Node3D
signal out

@export var highlight_hint: Node3D
@onready var candidate_tile_holder: Node3D = $CandidateTile
@onready var current_tile_holder: Node3D = $CurrentTile
@onready var cube_node: Node3D = $cube
@onready var bomb: Bomb = $Bomb
@onready var forbidden_marker: Sprite3D = %ForbiddenMarker

@onready var animations : CellAnimations = %CellAnimations

@export var placeable := true
var has_player := false : set = set_has_player
var has_bomb := false
var victory_cell := false
var is_set := false
var is_predrawn := false

var placing_tween: Tween
var predraw_tween: Tween
var rotate_tween: Tween

var normal_placing_elevation := 0.15
var replacing_elevation := 0.65
var on_player_elevation := 0.90

func _ready() -> void:
	highlight_hint.visible = false
	display_bomb()
	update_forbidden_marker()

func appear() -> void:
	scale = Vector3.ONE * .05
	var appear_tween := create_tween()
	var appear_duration := 4
	appear_tween \
		.tween_property(self, "scale", Vector3.ONE, appear_duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD )

func get_candidate_or_null() -> GameTile:
	for child in candidate_tile_holder.get_children():
		if child is GameTile:
			return child
	return null

func get_current_or_null() -> GameTile:
	for child in current_tile_holder.get_children():
		if child is GameTile:
			return child
	return null

func placing_available() -> bool:
	return (not is_set) and (placing_tween == null or (not placing_tween.is_running()))

func highlight(enable:bool) -> void:
	highlight_hint.visible = enable
	cube_node.visible = not enable

func set_has_player(s: bool) -> void:
	has_player = s

	if get_candidate_or_null() != null:
		set_holder_elevation()
	update_forbidden_marker()

func set_holder_elevation() -> void:
	if has_player:
		candidate_tile_holder.position.y = on_player_elevation
	elif get_current_or_null() != null:
		candidate_tile_holder.position.y = replacing_elevation
	else:
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
		set_holder_elevation()
		update_forbidden_marker()


func rotate_cell(rad: float) -> void:
	if not placing_available():
		return

	if abs(rad) > 0:
		if rotate_tween != null:
			rotate_tween.kill()

		rotate_tween = animations.block_rotation(self, rad)

func reset() -> void:
	forbidden_marker.visible = false

	highlight_hint.visible = false

	if(candidate_tile_holder.get_child_count() == 0):
		return

	candidate_tile_holder.remove_child(get_candidate_or_null())
	is_predrawn = false
	cube_node.visible = true

func place(show_animation: bool = true) -> bool:
	if has_player or not placeable:
		return false

	cube_node.visible = false
	#Reset animations
	if(predraw_tween):
		predraw_tween.stop()
		predraw_tween.kill()
	if(show_animation):
		Config.controls_available = false
		is_predrawn = false

		if get_current_or_null() != null:
			var prev_paths := get_current_or_null().find_children("*", "Path3D") as Array[Node]
			for p in prev_paths:
				p.remove_from_group(Config.PATH_GROUP)
			placing_tween = animations.replace_tile(self)
		else:
			placing_tween = animations.placing_animation(self)
		await placing_tween.finished

		Config.controls_available = true

	var candidate :=  get_candidate_or_null()
	if candidate == null:
		print("Weird no candidate")
		return false

	candidate_tile_holder.position.y = 0.0
	candidate.scale = Vector3.ONE
	candidate.position = Vector3.ZERO
	candidate.reparent(current_tile_holder)
	candidate.draw_props()

	var paths := candidate.find_children("*", "Path3D") as Array[Node]
	for path in paths:
		path.add_to_group(Config.PATH_GROUP)
	return true

func delete() -> void:
	if(has_bomb):
		bomb.explode()
	var tween := animations.shake_and_fell(self)
	tween.tween_callback(out.emit)
	tween.tween_interval(0.5)
	tween.tween_callback(queue_free)

func predraw_anim() -> void:
	if is_predrawn:
		predraw_tween = animations.size_blink(self)

func display_bomb() -> void:
	bomb.visible = has_bomb

func update_forbidden_marker()->void:
	forbidden_marker.visible = is_predrawn and (not placeable or has_player)
