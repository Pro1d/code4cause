class_name PrefabTile
extends Node

var scene : PackedScene
var rad : float
var has_bomb := false
var placeable := false
var trigger_victory_screen := false

func _init(s : PackedScene, r := 0., hb := false, p := false, trigger := false) -> void:
	scene = s
	rad = r
	has_bomb = hb
	placeable = p
	trigger_victory_screen = trigger

# you can use the following tiles to define your prefabs
#var tile_straight_blocking := preload("res://resources/placeholder/tile_straight_blocking.tscn")
#var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
#var tile_block := preload("res://resources/placeholder/tile_block.tscn")
enum FlipAxis {
	HORIZONTAL = 1,
	VERTICAL = 2,
	BOTH = 3,
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
	# TODO: if no bomb pattern has been given since X indicators, force it
	if indicator < 20:
		# easy ones
		all_prefab = [single_block, single_straight, single_turn]
		#all_prefab = [not_so_dead_end, not_so_dead_end, not_so_dead_end]
	elif indicator < 40:
		# ok ones
		all_prefab = [canyon, single_block, double_blocks, double_blocks_side, corner_top, bomb_top_corner]
	else:
		# evil ones
		all_prefab = [canyon, not_so_dead_end, double_blocks, double_blocks_side, uturn, bomb_hard, bomb_super_hard, bomb_dead_end, forced_jump, make_a_choice]
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
	var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
	return [
		[PrefabTile.new(tile_turn_blocking, PI/2*randi_range(0, 3))],
	]

static func single_straight() -> Array[Array]:
	var tile_straight_blocking := preload("res://resources/placeholder/tile_straight_blocking.tscn")
	return [
		[PrefabTile.new(tile_straight_blocking, PI/2*randi_range(0, 3))],
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
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(tile_block), null],
		[null, null, PrefabTile.new(tile_block), null],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(tile_block), null],
		[null, null, null, null],
		[null, null, PrefabTile.new(tile_turn_blocking, 3*PI/2), PrefabTile.new(tile_turn_blocking)],
	]

static func corner_top() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return randomly_flip([
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
		[null, PrefabTile.new(tile_block)],
	], FlipAxis.BOTH)

static func bomb_hard() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
	return [
		[PrefabTile.new(tile_turn_blocking,PI), null, null, null],
		[PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_turn_blocking), null , null],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, null],
	]

static func bomb_debug() -> Array[Array]:
	return [
		[PrefabTile.new(null, 0.0, true, true),
		PrefabTile.new(null, 0.0, true, true),
		PrefabTile.new(null, 0.0, true, true),
		PrefabTile.new(null, 0.0, true, true)]
	]

static func bomb_top_corner() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return randomly_flip([
		[null, PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
		[null, PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_block)],
	], FlipAxis.VERTICAL)

static func bomb_super_hard() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, null],
		[PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_turn_blocking, PI / 2.0), null, null],
		[PrefabTile.new(tile_turn_blocking, 3.0 * PI / 2.0), null, null, null]
	]

static func bomb_dead_end() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[null, PrefabTile.new(tile_block), null],
		[PrefabTile.new(tile_block), PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_block)],
	]

static func forced_jump() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_cross := preload("res://resources/placeholder/tile_cross.tscn")
	return randomly_flip([
		[null, PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(tile_block)],
		[null, PrefabTile.new(tile_block), null, null],
		[null, null, PrefabTile.new(tile_cross), null],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_block)],
	], FlipAxis.BOTH)

static func make_a_choice() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	var tile_turn_blocking := preload("res://resources/placeholder/tile_turn_blocking.tscn")
	var rand_dir:float = randi_range(0 ,1) * (PI / 2.0)
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
		[null, PrefabTile.new(tile_turn_blocking, PI + rand_dir), null, PrefabTile.new(tile_turn_blocking, rand_dir)],
		[null, null, PrefabTile.new(tile_block), null]
	]

static func not_so_dead_end() -> Array[Array]:
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return randomly_flip([
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_block), null, PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), null, null, null],
		[PrefabTile.new(tile_block), PrefabTile.new(null, 0.0, true, true), PrefabTile.new(tile_block), PrefabTile.new(null, 0.0, true, true)]
	], FlipAxis.BOTH)

static func victory_row() -> Array[Array]:
	var tile_straight_blocking := preload("res://resources/placeholder/tile_straight_blocking.tscn")
	var tile_block := preload("res://resources/placeholder/tile_block.tscn")
	return [
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking, 0.0, false, false, true), PrefabTile.new(tile_straight_blocking, 0.0, false, false, true), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
		[PrefabTile.new(tile_block), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_straight_blocking), PrefabTile.new(tile_block)],
	]
