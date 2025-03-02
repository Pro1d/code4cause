class_name Boss
extends Node

@export var health: int
@export var animator: BossAnimator

var is_dead := false

signal on_death

func take_damage(amount:int = 1) -> void:
	if(is_dead):
		return
		
	health = maxi(health - amount, 0)
	
	if(health <= 0):
		death()
	else:
		animator.damage()

func death() -> void:
	is_dead = true
	animator.death()
	on_death.emit()
