class_name TileViewportContainer
extends SubViewportContainer

@export var is_focus := false

var tile : Node3D

@onready var viewport : SubViewport = $TileViewport
@onready var camera : Camera3D = $TileViewport/Camera3D

func _ready() -> void:
	pass
	
func new_tile(tile_scene: PackedScene) -> void:
	if tile != null:
		tile.queue_free()
		
	tile = tile_scene.instantiate()
	viewport.add_child(tile)
		
	if is_focus:
		camera.fov = 50
	else:
		camera.fov = 75
	
func _process(delta: float) -> void:
	if tile != null and is_focus:
		tile.rotate_y(delta)
