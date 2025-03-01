class_name PlacementGrid
extends Node
signal tile_placed

var packed_straight : PackedScene = preload("res://resources/placeholder/tile_straight.tscn")

@export var width: int = 5
@export var height: int = 5
@export var cell_size: float = 1.0

@export var tile_scene: PackedScene
var placing_tile_scene: PackedScene

var cells: Array
var current_cell: PlacementCell
var current_pos: Vector2i
var grid_offset: Vector3 = Vector3(0,0,0)
var camera_offset_x :float = 0

func _ready() -> void:
	
	InitializeGrid()
	current_pos = Vector2(2,0)
	current_cell = cells[current_pos.x][current_pos.y]
	current_cell.highlight(placing_tile_scene)
	

func InitializeGrid() -> void:
	print(cell_size)
	for i:int in width:
		_generate_row()
		
	var initial_cell : PlacementCell = cells[0][2]
	initial_cell.highlight(packed_straight)
	initial_cell.rotate_cell(PI/2)
	initial_cell.place()
	initial_cell.reset()

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
	tile.global_position = grid_offset + Vector3(
		coord.x * cell_size + cell_size / 2.0, 0.0, 
	 	-coord.y * cell_size + cell_size / 2.0)

func place_tile() -> void:
	if(not current_cell.is_set):
		current_cell.place()
		tile_placed.emit()
	
	
func add_row()->void:
	_delete_first_row()
	current_pos += Vector2i.LEFT
	if(current_pos.x < 0):
		current_pos.x = 0
		move(Vector2i.ZERO)
	_generate_row()
	
func _delete_first_row() -> void:
	for i in (cells[0] as Array[PlacementCell]):
		i.delete()
	cells.pop_front()
		

func shift_back() -> void:
	for i:int in width:
		for j:int in range(1, height):
			var old_cell: PlacementCell = cells[i][j]
			(cells[i][j-1] as PlacementCell).redraw_child(old_cell.is_set, old_cell.current_tile_scene)
			old_cell.delete()
	
func _generate_row()->void:
	cells.append([])
	var i := len(cells) - 1
	grid_offset.x += cell_size
	for j:int in height:
		# Instantiate cell
		var cell: PlacementCell = tile_scene.instantiate()
		add_child(cell)
		cell.global_position = grid_offset + Vector3(cell_size / 2.0, 0.0, -j * cell_size + cell_size / 2.0)
		
		(cells[i] as Array).append(cell)
