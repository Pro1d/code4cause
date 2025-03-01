class_name PlayerMovement
extends Node

var path_follow := PathFollow3D.new()
var current_direction := 1
@onready var player : Player = get_parent()

var speed_factor := 0.0065 
func _ready() -> void:
	
	# $Player.global_position = transform * curve.get_point_position(0)
	path_follow.loop = false
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE
	
	player.global_position.x = -0.5
	player.global_position.z = -2 
	find_path()

func _process(delta: float) -> void:
	if(path_follow.get_parent() != null and path_follow != player.get_parent()):
		print(path_follow.get_path())
		player.reparent(path_follow)
	if (
		(current_direction == 1 and path_follow.progress_ratio >= 1) 
		or (current_direction == -1 and path_follow.progress_ratio <= 0)
		):
		find_path()
		
	path_follow.progress_ratio += delta*current_direction*player.speed*speed_factor

func find_path() -> void:
	print("Finding path")
	for path in get_tree().get_nodes_in_group(Config.PATH_GROUP):
		
		if path == path_follow.get_parent():
			continue
		var position_in_tile := (path as Node3D).global_transform.inverse() * player.global_position
		var curve := (path as Path3D).curve

		var next_parent : Path3D = null
		
		if true:
			print("Distance:")
			print("  0: %s" % curve.get_point_position(0).distance_squared_to(position_in_tile))
			print("  1: %s" % curve.get_point_position(1).distance_squared_to(position_in_tile))
			

		if curve.get_point_position(0).distance_squared_to(position_in_tile) < 0.1:
			next_parent = path
			current_direction = 1
			
		if curve.get_point_position(curve.point_count-1).distance_squared_to(position_in_tile) < 0.1:
			next_parent = path
			current_direction = -1
			
		if next_parent != null:
			if path_follow.get_parent() == null:
				next_parent.add_child(path_follow)
				print(path_follow.get_path())
				print(player.get_parent())
				print(path_follow.global_position.distance_to((path as Node3D).global_position))
			else:
				path_follow.reparent(next_parent, false)
				
			path_follow.progress_ratio = 0 if current_direction == 1 else 1
			player.global_rotation.y = 0
			player.current_cell = path.get_parent().get_parent().get_parent()
			Config.score += 1
			break
