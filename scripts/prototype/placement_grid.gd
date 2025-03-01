class_name PlacementGrid
extends Node

@export var width: int = 3
@export var height: int = 3
@export var cell_size: float = 1.0

@export var tile_scene: PackedScene

var cells: Array
var current_cell: PlacementCell
var current_pos: Vector2i

func _ready() -> void:
	InitializeGrid()
	current_cell = cells[0][0]
	current_pos = Vector2i.ZERO
	current_cell.highlight()

func InitializeGrid() -> void:
	for i:int in width:
		cells.append([])
		for j:int in height:
			# Instantiate cell
			var cell: PlacementCell = tile_scene.instantiate()
			add_child(cell)
			
			# Set 3D position
			cell.global_position = Vector3(i * cell_size + cell_size / 2.0, 0.0, j * cell_size + cell_size / 2.0)
			
			(cells[i] as Array).append(cell)

func move(dir: Vector2i) -> void:
	current_cell.reset()
	current_pos = (current_pos + dir).clamp(Vector2i.ZERO, Vector2i(width - 1, height - 1))
	current_cell = cells[current_pos.x][current_pos.y]
	current_cell.highlight()


func move_up() -> void:
	pass
		
func move_down() -> void:
	pass
	
func move_left() -> void:
	pass
	
func move_right() -> void:
	pass
