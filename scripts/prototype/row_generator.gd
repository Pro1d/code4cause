class_name RowGenerator
extends Node

var initial_cells_length := 2

var total_rows := 0
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
	elif total_rows > 3 and total_rows % 4 == 1:
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

	#if total_rows > 3 and total_rows % 3 == 1:
		#if randi()%3!=0:
			#var indexes: Array = [1,2] if randi()%2==0 else [0,3]
			#for i in indexes as Array[int]:
				#blocks[i] = PrefabTile.new(tile_block)
			#
	#if total_rows % 9 == 8:
		#var indexes: Array = [1,2,3] if randi()%2==0 else [0,1,2]
		#for i in indexes as Array[int]:
			#blocks[i] = PrefabTile.new(tile_block)

	total_rows += 1
	return blocks
