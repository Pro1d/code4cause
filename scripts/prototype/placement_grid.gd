class_name PlacementGrid
extends Node

@export var width: int = 5
@export var height: int = 5
@export var cell_size: float = 1.0

@export var tile_scene: PackedScene
@export var all_tiles_scenes: Array[PackedScene]
var placing_tile_scene: PackedScene
var placing_tile_index: int = 0

var cells: Array
var current_cell: PlacementCell
var current_pos: Vector2i
var offset: Vector3 = Vector3(0,0,0)

func _ready() -> void:
	placing_tile_scene = all_tiles_scenes[0]
	offset = Vector3(width,0,height)*(-cell_size)/2
	InitializeGrid()
	current_pos = Vector2(2,0)
	current_cell = cells[current_pos.x][current_pos.y]
	current_cell.highlight(placing_tile_scene)

func InitializeGrid() -> void:
	print(cell_size)
	for i:int in width:
		cells.append([])
		for j:int in height:
			# Instantiate cell
			var cell: PlacementCell = tile_scene.instantiate()
			add_child(cell)
			
			# Set 3D position
			cell.global_position = offset + Vector3(i * cell_size + cell_size / 2.0, 0.0, -j * cell_size + cell_size / 2.0)
			
			(cells[i] as Array).append(cell)

func move(dir: Vector2i) -> void:
	current_cell.reset()
	current_pos = (current_pos + dir).clamp(Vector2i.ZERO, Vector2i(width - 1, height - 1))
	current_cell = cells[current_pos.x][current_pos.y]
	if("highlight" in current_cell):
		current_cell.highlight(placing_tile_scene)

func rotate_cell(rad: float) -> void:
	current_cell.rotate_cell(rad)

func _place_tile(tile: Node3D, coord: Vector2i) -> void:
	var old :Node3D = cells[coord.x][coord.y]
	remove_child(old)
	add_child(tile)
	tile.global_position = offset + Vector3(
		coord.x * cell_size + cell_size / 2.0, 0.0, 
	 	-coord.y * cell_size + cell_size / 2.0)

func place_tile() -> void:
	current_cell.place()
	placing_tile_index = (placing_tile_index+1) % len(all_tiles_scenes)
	placing_tile_scene = all_tiles_scenes[placing_tile_index]
	
