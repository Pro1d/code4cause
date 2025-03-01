class_name  Player
extends Node3D

signal cell_changed(c: PlacementCell)

const cell_size : float = 1

var speed : float = 100
var current_cell : PlacementCell : set = set_current_cell

func _ready() -> void:
	pass
	
func set_current_cell(c: PlacementCell) -> void:
	current_cell = c
	cell_changed.emit(c)
