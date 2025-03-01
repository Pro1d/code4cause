extends MarginContainer

@onready var next_tiles_holders : Container = %NextTiles
@onready var grid: PlacementGrid = %GridPlacementScene/TileGrid

var all_tiles_scene : Array[PackedScene] = [
	preload("res://resources/placeholder/tile_straight.tscn"),
	preload("res://resources/placeholder/tile_turn.tscn"),
]

var next_tiles : Array[PackedScene] = []
var next_tiles_length: int = 4

func _ready() -> void:
	for i in next_tiles_length:
		add_next_tile()
	update_all_tiles()
	grid.placing_tile_scene = next_tiles[0]
	grid.tile_placed.connect(_on_tile_placed)
	grid.move(Vector2i(0,0))

func add_next_tile() -> void:
	next_tiles.append(all_tiles_scene.pick_random())
	
func _on_tile_placed() -> void:
	add_next_tile()
	next_tiles.pop_front()
	change_to_next_tiles()
	grid.placing_tile_scene = next_tiles[0]
	
func update_all_tiles() -> void:
	for i in next_tiles_holders.get_child_count():
		var current_holder : TileViewportContainer = next_tiles_holders.get_child(i)
		var tile_scene : PackedScene = next_tiles[next_tiles_length - 1 - i]
		current_holder.new_tile(tile_scene)

func change_to_next_tiles() -> void:
	#for i in next_tiles_holders.get_child_count():
		#var current_holder : TileViewportContainer = next_tiles_holders.get_child(i)
		#var tile_scene : PackedScene = next_tiles[next_tiles_length - 1 - i]
		#current_holder.new_tile(tile_scene)
	var last_holder : TileViewportContainer = next_tiles_holders.get_child(next_tiles_length - 1)
	last_holder.new_tile(next_tiles[0])
	last_holder.is_focus = false
	var tween := create_tween()
	tween.tween_property(last_holder, "modulate:a", 0.0, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(next_tiles_holders.move_child.bind(last_holder, 0))
	tween.tween_property(last_holder, "modulate:a", 1.0, 0.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	last_holder = next_tiles_holders.get_child(next_tiles_length - 1)
	last_holder.is_focus = true
