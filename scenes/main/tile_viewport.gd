class_name TileViewportContainer
extends SubViewportContainer

@export var is_focus := false :
	set(f):
		if f != is_focus:
			is_focus = f
			_update_focus_visual(true)

var tile : Node3D

@onready var viewport : SubViewport = $TileViewport
@onready var camera : Camera3D = $TileViewport/Camera3D

func _ready() -> void:
	_update_focus_visual(false)
	
func new_tile(tile_scene: PackedScene) -> void:
	if tile != null:
		tile.queue_free()
		
	tile = tile_scene.instantiate()
	# apply a random angle so the tiles won't all look the same in the preview
	tile.rotate_y(PI/2 * randi_range(0,3))
	viewport.add_child(tile)

var _tween_focus : Tween
func _update_focus_visual(animate: bool) -> void:
	if camera == null:
		return
	
	if _tween_focus != null:
		_tween_focus.kill()
		
	var target_fov := 50.0 if is_focus else 70.0
	
	if not animate:
		camera.fov = target_fov
		return
	
	_tween_focus = create_tween()
	_tween_focus.tween_property(camera, "fov", target_fov, 0.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _process(delta: float) -> void:
	if tile != null and is_focus:
		tile.rotate_y(delta * (TAU / 10))
