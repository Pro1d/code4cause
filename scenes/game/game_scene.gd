class_name GameScene
extends Node3D
signal tile_placed

@onready var grid: PlacementGrid = %TileGrid
@onready var camera: Camera3D = %Camera3D
@onready var input_controller: InputController = %InputController
@onready var player: Player = %Player
@onready var metronome: Metronome = $Metronome
@onready var background: Background = $Background

var next_tile: PackedScene : set = set_next_tile
var cell_size: float= 0
var camera_offset_x :float = 0

func _ready() -> void:
	cell_size = grid.cell_size
	input_controller.tile_grid = grid
	camera_offset_x = cell_size * 1.2
	camera.global_position.x = camera_offset_x

	grid.tile_placed.connect(on_tile_placed)

func on_tile_placed() -> void:
	tile_placed.emit()

func set_next_tile(nt: PackedScene) -> void:
	grid.placing_tile_scene = nt
	grid.move(Vector2i.ZERO)
	
func add_row() -> void:
	if player.current_cell in grid.cells[0]:
		get_tree().change_scene_to_file("res://scenes/menu/LooserMenu.tscn")
		
	grid.add_row()
	

func _process(_delta: float) -> void:
	#print("Camera: %s" % (camera.get_child(0) as Node3D).global_rotation)
	camera.global_position.x = camera_offset_x + metronome.time()
	background.offset_x = camera_offset_x + metronome.time()
