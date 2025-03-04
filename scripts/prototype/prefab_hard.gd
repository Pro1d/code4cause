extends Node

static func forced_jump() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_cross := preload("res://resources/placeholder/tile_cross.tscn")
	return [
		[null, PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
		[null, PrefabTile.new(tile_block), null, null],
		[null, null, PrefabTile.new(tile_cross), null],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
	]
