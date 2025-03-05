class_name GameScene
extends Node3D
signal tile_placed

@onready var grid: PlacementGrid = %TileGrid
@onready var camera: Camera3D = %Camera3D
@onready var input_controller: InputController = %InputController
@onready var player: Player = %Player
@onready var metronome: Metronome = $Metronome
@onready var background: Background = %Background
@onready var boss: Boss = $Camera3D/Boss


var next_tile: GameTile.Data : set = set_next_tile
var cell_size: float= 0
var camera_offset_x :float = 0

func _init() -> void:
	GameManager.game_scene = self

func _ready() -> void:
	cell_size = grid.cell_size
	input_controller.tile_grid = grid
	camera_offset_x = cell_size * 1.2
	camera.global_position.x = camera_offset_x

	grid.tile_placed.connect(on_tile_placed)
	
	player.died.connect(on_death)

func on_tile_placed() -> void:
	tile_placed.emit() 
	(camera as ShakeableCamera).camera_tile_small_shake()
	
func on_death() -> void:
	SceneManager.go_to_end_menu()

func set_next_tile(nt: GameTile.Data) -> void:
	grid.placing_tile_scene = nt.scene
	grid.grid_rotation = nt.angle()
	grid.move(Vector2i.ZERO)
	
func add_row() -> void:
	grid.add_row()

func _process(_delta: float) -> void:
	camera.global_position.x = camera_offset_x + metronome.time()
	
func damage_boss() -> void:
	boss.take_damage()
	(camera as ShakeableCamera).camera_shake()
