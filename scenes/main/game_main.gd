extends MarginContainer

@onready var next_tiles_holders : Container = %NextTiles
@onready var game_scene : GameScene = %GameScene
@onready var pause_menu: Control = $PauseMenu
@onready var fade_panel: UIFader = $FadePanel


var all_tiles_scene : Array[PackedScene] = [
	preload("res://resources/placeholder/tile_straight.tscn"),
	preload("res://resources/placeholder/tile_turn.tscn"),
	preload("res://resources/placeholder/tile_cross.tscn"),
]
var inventory: Array[PackedScene] = []

var next_tiles : Array[GameTile.Data] = []
var next_tiles_length: int = 4

var is_paused := false

func _ready() -> void:
	pause_menu.visible = false
	for i in next_tiles_length:
		add_next_tile()
	update_all_tiles()
	game_scene.tile_placed.connect(_on_tile_placed)
	game_scene.next_tile = next_tiles[0]
	fade_panel.fade_in()

func _reset_inventory() -> void:
	for i in range(2):
		inventory.push_back(all_tiles_scene[0])
	for i in range(3):
		inventory.push_back(all_tiles_scene[1])
	for i in range(1):
		inventory.push_back(all_tiles_scene[2])
	inventory.shuffle()

func add_next_tile() -> void:
	if inventory.is_empty():
		_reset_inventory()
	var tile := GameTile.Data.new()
	tile.scene = inventory.pop_back()
	tile.orientation = randi_range(0, 3)
	next_tiles.append(tile)

func _on_tile_placed() -> void:
	add_next_tile()
	next_tiles.pop_front()
	change_to_next_tiles()
	game_scene.next_tile = next_tiles[0]

func update_all_tiles() -> void:
	for i in range(next_tiles_holders.get_child_count() - 1):
		var current_holder : TileViewportContainer = next_tiles_holders.get_child(i)
		var tile := next_tiles[next_tiles_length - 1 - i]
		current_holder.new_tile(tile)

func change_to_next_tiles() -> void:
	var bottom_offset := %BottomOffset as Control
	var last_holder : TileViewportContainer = next_tiles_holders.get_child(next_tiles_length - 1)
	var next_holder : TileViewportContainer = next_tiles_holders.get_child(next_tiles_length - 2)

	last_holder.is_focus = false

	var tween := create_tween()
	tween.tween_property(last_holder, "modulate:a", 0.0, 0.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func() -> void:
		last_holder.new_tile(next_tiles[next_tiles_length - 1])
		next_tiles_holders.move_child(last_holder, 0)
		bottom_offset.custom_minimum_size.y = last_holder.custom_minimum_size.y
	)
	tween.tween_callback(func() -> void:
		next_holder.is_focus = true
	)
	tween.tween_property(bottom_offset, "custom_minimum_size:y", 0.0, .25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(last_holder, "modulate:a", 1.0, .5).from(0.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		pause()


func pause() -> void:
	is_paused = !is_paused
	print("is_paused: "+str(is_paused))
	pause_menu.visible = is_paused
	get_tree().paused = is_paused
