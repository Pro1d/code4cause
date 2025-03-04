class_name PrefabTile
extends Node

var scene : PackedScene
var rad : float
var has_bomb := false
var placeable := false

func _init(s : PackedScene, r := 0., hb := false, p := false) -> void:
	scene = s
	rad = r
	has_bomb = hb
	placeable = p

# you can use the following tiles to define your prefabs
#var tile_straight := preload("res://resources/placeholder/tile_straight.tscn")
#var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
#var tile_block := preload("res://resources/placeholder/tile_block.tscn")
enum FlipAxis {
	HORIZONTAL = 1,
	VERTICAL = 2,
}
static func randomly_flip(array: Array[Array], axis: FlipAxis) -> Array[Array]:
	var ret :Array[Array]= array.duplicate()
	if axis & FlipAxis.HORIZONTAL and randi_range(0, 1) == 1:
		ret.reverse()
	if axis & FlipAxis.VERTICAL and randi_range(0, 1) == 1:
		var temp := ret.duplicate()
		for column_index in range(temp.size()):
			ret[column_index] = (temp[column_index] as Array).duplicate()
			ret[column_index].reverse()
	return ret

static func random_prefab(indicator: int) -> Array[Array]:
	# TODO the idea would be to use a weighted list or something of the like
	var all_prefab: Array
	if indicator < 20:
		# easy ones
		#all_prefab = [single_block, single_straight, single_turn]
		all_prefab = [bomb_debug, bomb_debug, bomb_debug]
	elif indicator < 40:
		# ok ones
		all_prefab = [canyon, single_block, double_blocks, double_blocks_side]
	else:
		# evil ones
		all_prefab = [canyon, dead_end, double_blocks, double_blocks_side, uturn, bomb_hard, corner_top, corner_bottom]
	return (all_prefab.pick_random() as Callable).call()

static func canyon() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
	]

static func dead_end() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
	]

static func single_block() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block)],
	]

static func single_turn() -> Array[Array]:
	var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
	return [
		[PrefabTile.new(tile_turn, PI/2*randi_range(0, 3))],
	]

static func single_straight() -> Array[Array]:
	var tile_straight := preload("res://resources/placeholder/tile_straight.tscn")
	return [
		[PrefabTile.new(tile_straight, PI/2*randi_range(0, 3))],
	]

static func double_blocks() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
	]

static func double_blocks_side() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block)],
	]

static func uturn() -> Array[Array]:
	var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
	return [
		[PrefabTile.new(tile_turn, 3*PI/2), PrefabTile.new(tile_turn)],
	]

static func corner_top() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
		[null, PrefabTile.new(tile_block)],
	]

static func corner_bottom() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[null, PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
	]

static func bomb_hard() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_turn := preload("res://resources/placeholder/tile_turn.tscn")
	return [
		[PrefabTile.new(tile_turn,PI), null, null, null],
		[null, PrefabTile.new(tile_turn), null , null],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, null],
	]
	
static func bomb_debug() -> Array[Array]:
	return [
		[PrefabTile.new(null, 0.0, true, true), 
		PrefabTile.new(null, 0.0, true, true),
		PrefabTile.new(null, 0.0, true, true), 
		PrefabTile.new(null, 0.0, true, true)]
	]
