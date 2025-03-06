class_name GameTile
extends Node3D

class Data:
	var scene : PackedScene
	var orientation : int # range 0-3
	func angle() -> float:
		return orientation * PI / 2

var target_rot_y : float = 0.0
var tween_pop_in : Tween

@onready var props_front := $Props/Front as Node3D
@onready var props_back := $Props/Back as Node3D
@onready var props_center := $Props.find_child("Center", false) as Node3D
@onready var props_audio := %PropsPopAudio as AudioStreamPlayer

func _ready() -> void:
	# Initialize props:
	# - REMOVE props hidden in the editor (they cannot be used)
	# - HIDE by default the props that can be used
	var all_props :=  props_front.get_children() + props_back.get_children()
	if props_center != null:
		all_props += props_center.get_children()
	for prop: Node3D in all_props:
		if prop.visible:
			prop.hide()
		else:
			prop.queue_free()

func draw_props() -> void:
	if tween_pop_in != null:
		tween_pop_in.kill()
	tween_pop_in = create_tween()
	tween_pop_in.tween_interval(randf_range(0.1, 0.4))
	
	if props_center != null:
		var propCenter : int = randi_range(0, len(props_center.get_children())-1)
		var prop := (props_center.get_child(propCenter) as Node3D)
		show_prop_animation(prop)

	var propFront : int = randi_range(-1, len(props_front.get_children())-1)
	if propFront >=0:
		var prop := (props_front.get_child(propFront) as Node3D)
		show_prop_animation(prop)

	var propBack : int = randi_range(-1, len(props_back.get_children())-1)
	if propBack >=0:
		var prop := (props_back.get_child(propBack) as Node3D)
		show_prop_animation(prop)

	# TODO play pop sound

func show_prop_animation(prop: Node3D) -> void:
	prop.visible = true
	prop.scale = Vector3.ONE * 0.1
	tween_pop_in.tween_property(prop, "scale", Vector3.ONE, 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_pop_in.parallel().tween_callback(props_audio.play)
