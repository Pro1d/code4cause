class_name PlayerMovement
extends Node

# Audios
@onready var car_engine_player: AudioStreamPlayer = $"../AudioPlayers/CarStartPlayer"
@onready var car_accelerate_player: AudioStreamPlayer = $"../AudioPlayers/CarAcceleratePlayer"


var path_follow := PathFollow3D.new()
var current_direction := 1
@onready var player : Player = get_parent()
var next_checked := false
var max_edge_ratio := 0.2
var speed_factor := 0.0065

func _ready() -> void:

	# $Player.global_position = transform * curve.get_point_position(0)
	path_follow.loop = false
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE

	player.global_position.x = -0.5
	player.global_position.z = -1
	find_player_path()

func _process(delta: float) -> void:
	if(path_follow.get_parent() != null and path_follow != player.get_parent()):
		print(path_follow.get_path())
		player.reparent(path_follow)
		path_follow.progress_ratio = 0.5

	if (player.global_position.z > 0.5-max_edge_ratio - 0.1) or (player.global_position .z <= -3.5 + max_edge_ratio + 0.1 )  :
		car_accelerate_player.play()
		current_direction = -current_direction

	if (
		(current_direction == 1 and path_follow.progress_ratio >= 1)
		or (current_direction == -1 and path_follow.progress_ratio <= 0)
		):
		find_player_path()

	# Check if next
	var next_ratio := path_follow.progress_ratio + delta*current_direction*player.speed*speed_factor

	if (not next_checked and (
		(current_direction<0 and next_ratio < max_edge_ratio)
		or  (current_direction>0 and next_ratio > (1-max_edge_ratio ))
	)):
		# Do not go to the edge if there is nothing
		var path := (path_follow.get_parent() as Path3D)
		var curve := path.curve
		var index_to_check := 0 if current_direction < 0 else (curve.point_count-1)
		var point_to_check := path.global_transform * curve.get_point_position(index_to_check)
		var target := find_path(point_to_check)
		if target != null:
			next_checked = true
			path_follow.progress_ratio = next_ratio
	else:
		path_follow.progress_ratio = next_ratio

func find_player_path() -> void:
	var next_parent := find_path(player.global_position, true)
	if next_parent != null:
		if path_follow.get_parent() == null:
			next_parent.add_child(path_follow)
		else:
			path_follow.reparent(next_parent, false)

		path_follow.progress_ratio = 0 if current_direction == 1 else 1
		player.global_rotation.y = 0
		player.current_cell = next_parent.get_parent().get_parent().get_parent()
		Config.score += 1
		next_checked = false

func find_path(position_to_check: Vector3, change_direction : bool = false) -> Path3D:
	if(!get_tree()): return

	for path in get_tree().get_nodes_in_group(Config.PATH_GROUP):
		if path == path_follow.get_parent():
			continue

		var position_in_tile := (path as Node3D).to_local(position_to_check)
		var curve := (path as Path3D).curve

		var next_parent : Path3D = null

		if false:
			print("Distance:")
			print("  0: %s" % curve.get_point_position(0).distance_squared_to(position_in_tile))
			print("  1: %s" % curve.get_point_position(1).distance_squared_to(position_in_tile))

		if curve.point_count == 1 :
			# Dead end marker
			if curve.get_point_position(0).distance_squared_to(position_in_tile) < 0.1 and change_direction:
				current_direction = -current_direction
				return null

		# Navigable Path

		if curve.get_point_position(0).distance_squared_to(position_in_tile) < 0.1:
			next_parent = path
			if change_direction:
				current_direction = 1

		if curve.get_point_position(curve.point_count-1).distance_squared_to(position_in_tile) < 0.1:
			next_parent = path
			if change_direction:
				current_direction = -1

		if next_parent != null:
			return next_parent
	return null
