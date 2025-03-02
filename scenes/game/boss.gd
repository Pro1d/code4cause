class_name Boss
extends Node

@export var health: int

signal on_death

func take_damage(amount:int = 1) -> void:
	health = maxi(health - amount, 0)
	if(health <= 0):
		death()

func death() -> void:
	# TODO: Animate
	on_death.emit()
