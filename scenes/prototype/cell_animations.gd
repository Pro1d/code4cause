class_name  CellAnimations
extends Node

func shake_and_fell(c: Node3D, shake_count := 8) -> Tween:
	var shake_magnitude := 0.07 # m
	var shake_duration := 0.1 # s
	var gpos := c.global_position
	var tween := c.create_tween()
	tween.tween_interval(randf() * 0.4)
	var shake_offset := Vector3(1, 0, 0).rotated(Vector3.UP, randf() * TAU)
	for i in range(shake_count):
		var shake_factor := pow(float(i + 1) / shake_count, 2.0)
		var shake := shake_offset * shake_magnitude * shake_factor
		var t := tween.parallel() if i > 0 else tween
		t.tween_property(c, "global_position", gpos + shake, shake_duration) \
			.set_delay(i * shake_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		shake_offset = shake_offset.rotated(Vector3.UP, deg_to_rad(180.0 + randf_range(-20.0, 20.0)))
	tween.parallel().tween_property(c, "global_position:y", -5.0, 1.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD) \
		.set_delay(shake_count * shake_duration * .85)

	return tween

func replace_tile(c: PlacementCell) -> Tween:
	var shake_magnitude := 0.09 # m
	var offset_delay := 0.2
	var placing_duration : = 0.2
	var shake_count := 2
	var fall_duration := 0.2
	var shake_duration := 0.08 # s

	var previous := c.get_current_or_null()
	var next := c.get_candidate_or_null()
	var next_holder : Node3D = c.candidate_tile_holder

	var prev_tween := c.create_tween()
	var next_tween := c.create_tween()

	# Shake previous

	var prev_gpos := previous.global_position
	var next_gpos := next.global_position
	prev_tween.tween_interval(randf() * 0.4)
	var shake_offset := Vector3(1, 0, 0).rotated(Vector3.UP, randf() * TAU)
	for i in range(shake_count):
		var shake_factor := pow(float(i + 1) / shake_count, 2.0)
		var shake := shake_offset * shake_magnitude * shake_factor


		var t := prev_tween.parallel() if i > 0 else prev_tween
		t.tween_property(previous, "global_position", prev_gpos + shake, shake_duration) \
				.set_delay(i * shake_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

		var t2 := next_tween.parallel() if i > 0 else next_tween
		t2.tween_property(next, "global_position", next_gpos + shake, shake_duration) \
				.set_delay(i * shake_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

		shake_offset = shake_offset.rotated(Vector3.UP, deg_to_rad(180.0 + randf_range(-20.0, 20.0)))

	prev_tween.parallel().tween_property(previous, "global_position:y", -5.0, fall_duration) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD) \
		.set_delay(shake_count * shake_duration * .85)

	prev_tween.tween_callback(previous.queue_free)

	# Var placing tween

	next_tween.tween_interval((shake_duration * shake_count) + offset_delay)
	next_tween.tween_property(next_holder, "position:y", 0, placing_duration) \
		.set_ease(Tween.EASE_IN)

	return next_tween


func placing_animation(c: PlacementCell) -> Tween:
	var duration : = 0.1
	var tween := c.create_tween()

	tween.tween_property(c.candidate_tile_holder, "position:y", 0, duration) \
		.set_ease(Tween.EASE_IN)

	return tween

func size_blink(c: PlacementCell) -> Tween:
	var child: GameTile = c.get_candidate_or_null()
	var tween := c.create_tween()
	if child != null:
		tween.tween_property(child, "scale", 0.8 *Vector3.ONE, 0.1) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_OUT)
		tween.tween_property(child, "scale",  0.9*Vector3.ONE, 0.1) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_IN)
	return tween

func block_rotation(c: PlacementCell, rad: float) -> Tween:
	var tile_scene := c.get_candidate_or_null()
	var duration := 0.3
	var current_angle := tile_scene.rotation.y
	tile_scene.target_rot_y += rad
	var target_angle := current_angle + angle_difference(current_angle, tile_scene.target_rot_y)
	var tween := c.create_tween()
	tween \
		.tween_property(tile_scene, "rotation:y", target_angle, duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD )
	tween.parallel() \
		.tween_property(tile_scene, "scale", 0.7*Vector3.ONE, duration/2)
	tween.tween_property(tile_scene, "scale", Vector3.ONE, duration/2)

	return tween
