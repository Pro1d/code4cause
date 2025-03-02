class_name Boss
extends Node

@export var health: int
@export var animator: BossAnimator

signal on_death

func _ready() -> void:
	animator.idle()

func take_damage(amount:int = 1) -> void:
	animator.damage()
	health = maxi(health - amount, 0)
	if(health <= 0):
		death()

func death() -> void:
	animator.death()
	on_death.emit()
