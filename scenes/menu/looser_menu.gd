extends Control

func _ready() -> void:
	($Panel/ScoreLabel as Label).text = "Score: %d" % Config.score
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		restart()

func restart() -> void:
	Config.score = 0
	get_tree().change_scene_to_file("res://scenes/main/GameMain.tscn")
	
