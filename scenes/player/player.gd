class_name  Player
extends Node3D

signal died
signal cell_changed(c: PlacementCell)

const cell_size : float = 1

var speed : float = 100
var current_cell : PlacementCell : set = set_current_cell

func _ready() -> void:
	pass
	
func set_current_cell(c: PlacementCell) -> void:
	if current_cell != null:
		current_cell.out.disconnect(on_death)
		current_cell.has_player = false
	current_cell = c
	cell_changed.emit(c)
	current_cell.out.connect(on_death)
	c.has_player = true

func on_death() -> void:
	died.emit()
