class_name RowGenerator
extends Node

var initial_cells_length := 3

var total_rows := 0
var consecutive_empty_lines := 0
var tile_straight := preload("res://resources/placeholder/tile_straight.tscn")
var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
var tile_block := preload("res://resources/placeholder/tile_block.tscn")

# it's an Array of Array[PrefabTile]
var buffer : Array[Array] = []

func get_row(height: int) -> Array[PrefabTile]:
	var blocks : Array[PrefabTile] = []
	blocks.resize(height)

	# start the level with straight lines
	if total_rows < initial_cells_length:
		blocks[1] = PrefabTile.new(tile_straight)

	# if we have a shape in memory draw it before anything
	if len(buffer) > 0:
		var tmp : Array = buffer.pop_front()
		for row in len(tmp):
			blocks[row] = tmp[row]
		consecutive_empty_lines = 0
	elif total_rows > 5 and(
		(consecutive_empty_lines >= 3)
		or (total_rows > 15 and consecutive_empty_lines >= 2)
		or (total_rows > 30 and consecutive_empty_lines >= 1)
		):
		var prefab := PrefabTile.random_prefab(total_rows)

		# compute a delta so we can place the prefab somewhere within the height's range
		var delta := randi_range(0, height-len(prefab[0]))

		var front : Array = prefab.pop_front()
		for i in len(front):
			blocks[i+delta] = front[i]

		# put the rest in the buffer
		for col in prefab:
			var tmp : Array
			tmp.resize(height)
			for row in len(col):
				tmp[row + delta] = col[row]
			buffer.push_back(tmp)
		consecutive_empty_lines = 0
	else:
		consecutive_empty_lines += 1

	total_rows += 1
	return blocks

func get_victory_row(height: int) -> Array[PrefabTile]:
	var blocks : Array[PrefabTile] = []
	blocks.resize(height)

	# if we have a shape in memory draw it before anything
	if len(buffer) > 0:
		var tmp : Array = buffer.pop_front()
		for row in len(tmp):
			blocks[row] = tmp[row]
		consecutive_empty_lines = 0
	if total_rows > 3 and(
		(consecutive_empty_lines >= 3)
		or (total_rows > 15 and consecutive_empty_lines >= 2)
		or (total_rows > 30 and consecutive_empty_lines >= 1)
		):
		var prefab := PrefabTile.victory_row()

		# compute a delta so we can place the prefab somewhere within the height's range
		var delta := randi_range(0, height-len(prefab[0]))

		var front : Array = prefab.pop_front()
		for i in len(front):
			blocks[i+delta] = front[i]

		# put the rest in the buffer
		for col in prefab:
			var tmp : Array
			tmp.resize(height)
			for row in len(col):
				tmp[row + delta] = col[row]
			buffer.push_back(tmp)
		consecutive_empty_lines = 0
	else:
		consecutive_empty_lines += 1

	total_rows += 1
	return blocks
