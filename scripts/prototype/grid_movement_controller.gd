class_name InputController
extends Node


var tile_grid: PlacementGrid

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("move_up")):
		tile_grid.move(Vector2i.DOWN)
	elif(event.is_action_pressed("move_down")):
		tile_grid.move(Vector2i.UP)
	elif(event.is_action_pressed("move_left")):
		tile_grid.move(Vector2i.LEFT)
	elif(event.is_action_pressed("move_right")):
		tile_grid.move(Vector2i.RIGHT)
	elif(event.is_action_pressed("rotate_left")):
		tile_grid.rotate_cell(PI/2)
	elif(event.is_action_pressed("rotate_right")):
		tile_grid.rotate_cell(-PI/2)
	elif(event.is_action_pressed("ui_accept")):
		tile_grid.place_tile()

#func _process(delta: float) -> void:
	#get_viewport().get_mouse_position()
