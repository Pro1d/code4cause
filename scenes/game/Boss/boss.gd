class_name Boss
extends Node

@export var health: int
@export var animator: BossAnimator

# Audios
@onready var damage_player: AudioStreamPlayer = $AudioPlayers/DamagePlayer
@onready var death_player: AudioStreamPlayer = $AudioPlayers/DeathPlayer

var is_dead := false

signal on_death

func take_damage(amount:int = 1) -> void:
	if(is_dead):
		return

	print(health)
	health = maxi(health - amount, 0)

	if(health <= 0):
		GameManager.end()
	else:
		damage_player.play()
		animator.damage()

func death() -> void:
	is_dead = true
	death_player.play()
	animator.death()
	on_death.emit()
