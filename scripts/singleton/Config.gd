extends Node
signal score_changed(new_score: int)
const PATH_GROUP = "player_path"

var controls_available := true
var score := 0 : set = set_score
var best_score := 0

func set_score(s: int) -> void:
	score = s
	if score > best_score:
		best_score = score
	score_changed.emit(s)

func reset_game() -> void:
	score = 0
	controls_available = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if is_window \
			else DisplayServer.WINDOW_MODE_WINDOWED)
