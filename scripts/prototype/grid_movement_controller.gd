class_name InputController
extends Node

var tile_grid: PlacementGrid
var reset_hold_time: float = 1.0
var current_reset_hold_time: float = 0.0

func _input(event: InputEvent) -> void:
	if Config.controls_available:
		# Move in grid
		if(event.is_action_pressed("move_up")):
			tile_grid.move(Vector2i.DOWN)
		elif(event.is_action_pressed("move_down")):
			tile_grid.move(Vector2i.UP)
		elif(event.is_action_pressed("move_left")):
			tile_grid.move(Vector2i.LEFT)
		elif(event.is_action_pressed("move_right")):
			tile_grid.move(Vector2i.RIGHT)
		# Rotate tile
		elif(event.is_action_pressed("rotate_left")):
			tile_grid.rotate_cell(PI/2)
		elif(event.is_action_pressed("rotate_right")):
			tile_grid.rotate_cell(-PI/2)
		# Place tile
		elif(event.is_action_pressed("ui_accept")):
			tile_grid.place_tile()
		# Reset
		elif(event.is_action("reset")):
			handle_reset()
		elif(event.is_action_released("reset")):
			current_reset_hold_time = 0.0
		#elif(event.is_action_released("ui_end")):
			#GameManager.end()

func handle_reset() -> void:
	current_reset_hold_time += get_process_delta_time()
	if(current_reset_hold_time >= reset_hold_time):
			get_tree().change_scene_to_file("res://scenes/main/GameMain.tscn")
