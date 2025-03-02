class_name RowGenerator
extends Node

var initial_cells_length := 2

var total_rows := 0 
var tile_straight := preload("res://resources/placeholder/tile_straight.tscn")
var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
var tile_block := preload("res://resources/placeholder/tile_block.tscn")


func get_row(height: int) -> Array[PackedScene]:
	print("Generating: %d" % total_rows)
	var blocks : Array[PackedScene] = []
	blocks.resize(height)
	
	if total_rows < initial_cells_length:
		print("-> blocks %s" % tile_straight)
		blocks[1] = tile_straight
	
	if total_rows > 3 and total_rows % 3 == 1:
		if randi()%3!=0:
			var indexes: Array = [1,2] if randi()%2==0 else [0,3]
			for i in indexes as Array[int]:
				blocks[i] = tile_block
			
	if total_rows % 9 == 8:
		var indexes: Array = [1,2,3] if randi()%2==0 else [0,1,2]
		for i in indexes as Array[int]:
			blocks[i] = tile_block
	
	total_rows += 1
	
	print(blocks)
	return blocks
