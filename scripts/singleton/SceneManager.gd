extends Node

func go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func go_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main/GameMain.tscn")

func go_to_end_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/LooserMenu.tscn")
	
func go_to_victory_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/VictoryMenu.tscn")
