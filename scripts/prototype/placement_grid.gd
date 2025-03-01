class_name PlacementGrid
extends Node
signal tile_placed

var packed_straight : PackedScene = preload("res://resources/placeholder/tile_straight.tscn")

@export var width: int = 6
@export var height: int = 4
@export var cell_size: float = 1.0

@export var tile_scene: PackedScene
var placing_tile_scene: PackedScene

var cells: Array
var current_cell: PlacementCell
var highlighted_cell: PlacementCell
var current_pos: Vector2i
var grid_offset: Vector3 = Vector3(0,0,0)
var camera_offset_x :float = 0
var grid_rotation: float

func _ready() -> void:
	
	InitializeGrid()
	current_pos = Vector2(1,2)
	current_cell = cells[current_pos.x][current_pos.y]
	current_cell.predraw(placing_tile_scene, grid_rotation)
	highlighted_cell = current_cell
	highlighted_cell.highlight(true)
	

func InitializeGrid() -> void:
	for i:int in width:
		_generate_row()
		
	var initial_cell : PlacementCell = cells[0][2]
	initial_cell.predraw(packed_straight, 0.0)
	initial_cell.place()
	initial_cell.reset()

func move(dir: Vector2i) -> void:
	highlighted_cell.highlight(false)
	set_current_cell(current_pos + dir)

func set_current_cell(pos: Vector2i) -> void:
	current_pos = pos.clamp(Vector2i.ZERO, Vector2i(width - 1, height - 1))
	highlighted_cell = cells[current_pos.x][current_pos.y] as PlacementCell
	highlighted_cell.highlight(true)
	
	# Forbid placement if cell is occupied
	if((cells[current_pos.x][current_pos.y] as PlacementCell).is_set):
		return
		
	current_cell.reset()
	current_cell = cells[current_pos.x][current_pos.y]
	if("predraw" in current_cell):
		current_cell.predraw(placing_tile_scene, grid_rotation)

func rotate_cell(rad: float) -> void:
	grid_rotation += rad
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
		current_pos = get_closest_available_cell(current_pos.x, current_pos.y)
		highlighted_cell = (cells[current_pos.x][current_pos.y] as PlacementCell)
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
	for j:int in height:
		# Instantiate cell
		var cell: PlacementCell = tile_scene.instantiate()
		add_child(cell)
		cell.global_position = grid_offset + Vector3(0, 0.0, -j * cell_size)
		
		(cells[i] as Array).append(cell)
	grid_offset.x += cell_size


func get_closest_available_cell(x:int, y:int) -> Vector2i:
	# Directions for 4-way movement (up, down, left, right)
	var directions := [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]

	# Queue for BFS (stores (x, y) positions)
	var queue := [Vector2i(x, y)]
	var visited := {}

	# Start BFS
	while queue:
		var current:Vector2i = queue.pop_front()
		var cx:int = current.x
		var cy:int = current.y

		# Check bounds
		if cx < 0 or cy < 0 or cx >= width or cy >= height:
			continue

		# Skip already visited positions
		if visited.has(current):
			continue
		visited[current] = true

		# Return the position if it's False
		if not (cells[cx][cy] as PlacementCell).is_set :
			return current  # Found the closest false value!

		# Add neighbors to the queue
		for direction:Vector2i in directions:
			var nx:int = cx + direction.x
			var ny:int = cy + direction.y
			if nx >= 0 and ny >= 0 and nx < width and ny < height:
				queue.append(Vector2i(nx, ny))

	return Vector2i(-1, -1)  # No false value found


func animate_predrawn_cell() -> void:
	if not current_cell.is_queued_for_deletion():
		current_cell.predraw_anim()
