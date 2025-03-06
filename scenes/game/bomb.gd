class_name Bomb
extends Node3D

@onready var explosion_particles: CPUParticles3D = $ExplosionParticles
@onready var fuse_particles: CPUParticles3D = $FuseParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_3d: Sprite3D = $Sprite3D

# Audios
@onready var lit_up_player: AudioStreamPlayer = $AudioPlayers/LitUpPlayer
@onready var fuse_player: AudioStreamPlayer = $AudioPlayers/FusePlayer
@onready var explosion_player: AudioStreamPlayer = $AudioPlayers/ExplosionPlayer


var is_lit := false
var base_position: Vector3

func lit_up() -> void:
	is_lit = true
	lit_up_player.play()
	fuse_player.play()
	animation_player.current_animation = "bomb_lit_up"
	fuse_particles.emitting = true
	base_position = position
	
func explode() -> void:
	if(!is_lit):
		return
	fuse_player.stop()
	explosion_player.play()
	sprite_3d.visible = false
	fuse_particles.visible = false
	explosion_particles.emitting = true
	GameManager.game_scene.damage_boss()
