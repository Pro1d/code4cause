class_name grid_movement_controller
extends Node3D

@onready var tile_grid: PlacementGrid = $"../TileGrid"

var input_direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
