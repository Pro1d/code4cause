extends Node

var game_scene: GameScene

func end() -> void:
	game_scene.boss.death()
	game_scene.grid.victory = true
	pass
