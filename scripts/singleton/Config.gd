extends Node
signal score_changed(new_score: int)
const PATH_GROUP = "player_path"

var score := 0 : set = set_score

func set_score(s: int) -> void:
	score = s
	score_changed.emit(s)
