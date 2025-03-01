class_name PlayerMovement
extends Node3D
var path_follow = PathFollow3D.new()
var sign = 1
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# $Player.global_position = transform * curve.get_point_position(0)
	path_follow.loop = false
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE
	$TileAngle/Path3D.add_child(path_follow)

	player.reparent(path_follow, false)



	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	print(path_follow.progress_ratio)
	if (sign == 1 and path_follow.progress_ratio >= 1) or (sign == -1 and path_follow.progress_ratio <= 0):
		for path in get_tree().get_nodes_in_group("PlayerPath"):
			print(path)
			if path == path_follow.get_parent():
				continue
			var position_in_tile = (path as Node3D).global_transform.inverse() * player.global_position
			var curve := (path as Path3D).curve
			if curve.get_point_position(0).distance_squared_to(position_in_tile) < 0.01:
				path_follow.reparent(path)
				path_follow.progress_ratio=0
				sign = 1
				break
			if curve.get_point_position(curve.point_count-1).distance_squared_to(position_in_tile) < 0.01:
				path_follow.reparent(path)
				path_follow.progress_ratio=1
				sign = -1
				break
	path_follow.progress_ratio += delta*sign

