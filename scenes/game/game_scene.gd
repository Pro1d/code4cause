class_name GameScene
extends Node3D
signal tile_placed

@onready var grid: PlacementGrid = %TileGrid
@onready var camera: Camera3D = %Camera3D
@onready var input_controller: InputController = %InputController
@onready var player: Player = %Player

var next_tile: PackedScene : set = set_next_tile
var cell_size: float= 0
var camera_offset_x :float = 0

func _ready() -> void:
	cell_size = grid.cell_size
	input_controller.tile_grid = grid
	camera_offset_x = grid.grid_offset.x -(3*cell_size)/2
	camera.global_position.x = camera_offset_x

	grid.tile_placed.connect(on_tile_placed)
	input_controller.add_row.connect(add_row)

func on_tile_placed() -> void:
	tile_placed.emit()

func set_next_tile(nt: PackedScene) -> void:
	grid.placing_tile_scene = nt
	grid.move(Vector2i.ZERO)
	
func add_row() -> void:
	grid.add_row()
	camera_offset_x += cell_size

func _process(delta: float) -> void:
	camera.global_position.x = lerpf(camera.global_position.x, camera_offset_x, delta)
