class_name ShakeableCamera
extends Camera3D

@export var period := 0.3
@export var magnitude := 0.4

func camera_shake() -> void:
	var initial_transform: = transform 
	var elapsed_time := 0.0

	while elapsed_time < period and is_inside_tree():
		var offset := Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform

func camera_tile_small_shake() -> void:
	var initial_transform: = transform 
	var elapsed_time := 0.0

	while elapsed_time < 0.1:
		var offset := Vector3(
			0.0,
			randf_range(-magnitude * 0.05, magnitude * 0.05),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform
	
