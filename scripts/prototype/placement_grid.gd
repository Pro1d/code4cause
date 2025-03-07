class_name PlacementGrid
extends Node
signal tile_placed

@export var width: int = 6
@export var extra_width: int = 1
@export var height: int = 4
@export var initial_column : int = 1
@export var cell_size: float = 1.0
@export var tile_scene: PackedScene

@onready var row_generator : RowGenerator = RowGenerator.new()

# Audios
@onready var collapse_sfx_player: AudioStreamPlayer = $"../AudioStreamPlayers/CollapseSFXPlayer"


var placing_tile_scene: PackedScene

var cells: Array
var current_cell: PlacementCell
var highlighted_cell: PlacementCell
var current_pos: Vector2i
var grid_offset: Vector3 = Vector3(0,0,0)
var camera_offset_x :float = 0
var grid_rotation: float
var victory := false

func _ready() -> void:
	initialize_grid()
	current_pos = Vector2(row_generator.initial_cells_length,initial_column)
	current_cell = cells[current_pos.x][current_pos.y]
	current_cell.predraw(placing_tile_scene, grid_rotation)
	highlighted_cell = current_cell
	highlighted_cell.highlight(true)

func initialize_grid() -> void:
	for i:int in (width+extra_width):
		_generate_row()

func move(dir: Vector2i) -> void:
	highlighted_cell.highlight(false)
	set_current_cell(current_pos + dir)

func set_current_cell(pos: Vector2i) -> void:
	current_pos = pos.clamp(Vector2i.ZERO, Vector2i(width - 1, height - 1))
	highlighted_cell = cells[current_pos.x][current_pos.y] as PlacementCell
	highlighted_cell.highlight(true)

	# Forbid placement if cell is occupied
	if(not highlighted_cell.placing_available()):
		return

	current_cell.reset()
	current_cell = highlighted_cell
	if("predraw" in current_cell):
		current_cell.predraw(placing_tile_scene, grid_rotation)

func rotate_cell(rad: float) -> void:
	grid_rotation += rad
	current_cell.rotate_cell(rad)

func place_tile() -> void:
	if(current_cell.placing_available()):
		if await current_cell.place():
			tile_placed.emit()

func add_row()->void:
	if(victory):
		_spawn_victory_row()
	else:
		_generate_row(true)

	await get_tree().create_timer(0.5).timeout
	_delete_first_row()
	current_pos += Vector2i.LEFT
	if(current_pos.x < 0):
		current_pos.x = 0
		move(Vector2i.ZERO)

func _delete_first_row() -> void:
	collapse_sfx_player.play()
	for i in (cells[0] as Array[PlacementCell]):
		i.delete()
	cells.pop_front()

func _generate_row(appear_animation: bool = false)->void:
	cells.append([])
	var i := len(cells) - 1

	var rows_elements := row_generator.get_row(height)

	for j:int in height:
		# Instantiate cell
		var cell: PlacementCell = tile_scene.instantiate()
		add_child(cell)
		cell.global_position = grid_offset + Vector3(0, 0.0, -j * cell_size)

		if(rows_elements[j] != null):
			# Handle bomb
			cell.has_bomb = rows_elements[j].has_bomb
			cell.display_bomb()

			# Set other attributes
			if(rows_elements[j].scene != null):
				cell.predraw(rows_elements[j].scene, rows_elements[j].rad)
				cell.place(false)
				cell.reset()
				cell.placeable = rows_elements[j].placeable
				cell.get_current_or_null().set_locked()


		if appear_animation:
			cell.appear()

		(cells[i] as Array).append(cell)
	grid_offset.x += cell_size

func _spawn_victory_row() -> void:
	cells.append([])
	var i := len(cells) - 1

	var rows_elements := row_generator.get_victory_row(height)

	for j:int in height:
		# Instantiate cell
		var cell: PlacementCell = tile_scene.instantiate()
		add_child(cell)
		cell.global_position = grid_offset + Vector3(0, 0.0, -j * cell_size)

		if(rows_elements[j] != null):
			cell.victory_cell = rows_elements[j].trigger_victory_screen

			# Set other attributes
			if(rows_elements[j].scene != null):
				cell.predraw(rows_elements[j].scene, rows_elements[j].rad)
				cell.place(false)
				cell.reset()
				cell.placeable = rows_elements[j].placeable

		cell.appear()

		(cells[i] as Array).append(cell)
	grid_offset.x += cell_size


# Currently unused
func get_closest_available_cell(x:int, y:int) -> Vector2i:
	# Directions for 4-way movement (up, down, left, right)
	var directions := [Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0)]

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
		if not (cells[cx][cy] as PlacementCell).placing_available() :
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
