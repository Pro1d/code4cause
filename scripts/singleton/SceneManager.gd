extends Node

var ui_fader: UIFader

func go_to_main_menu() -> void:
	if ui_fader != null:
		await ui_fader.fade_out()
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func go_to_game() -> void:
	if ui_fader != null:
		await ui_fader.fade_out()
	get_tree().change_scene_to_file("res://scenes/main/GameMain.tscn")

func reset_game_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/main/GameMain.tscn")

func go_to_end_menu() -> void:
	if ui_fader != null:
		await ui_fader.fade_out()
	get_tree().change_scene_to_file("res://scenes/menu/LooserMenu.tscn")

func go_to_victory_menu() -> void:
	if ui_fader != null:
		await ui_fader.fade_out()
	get_tree().change_scene_to_file("res://scenes/menu/VictoryMenu.tscn")
