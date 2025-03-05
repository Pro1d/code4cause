class_name Bomb
extends Node3D

@onready var explosion_particles: CPUParticles3D = $ExplosionParticles
@onready var fuse_particles: CPUParticles3D = $FuseParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_lit := false
var base_position: Vector3

func lit_up() -> void:
	is_lit = true
	animation_player.current_animation = "bomb_lit_up"
	fuse_particles.emitting = true
	base_position = position
	
func explode() -> void:
	if(!is_lit):
		return
	explosion_particles.emitting = true
	GameManager.game_scene.damage_boss()
