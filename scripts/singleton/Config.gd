extends Node
signal score_changed(new_score: int)
const PATH_GROUP = "player_path"
var config := ConfigFile.new()

enum Mode {
	Normal,
	Endless
}

var controls_available := true

var endless_mode_unlocked := false
var game_mode := Mode.Normal
var score := 0 : set = set_score
var kms := 0
var bombs_count := 0
var best_score := 0

func load_progression() -> void:
	var err := config.load("user://save.cfg")
	# If the file didn't load, ignore it.
	if err != OK:
		return
	endless_mode_unlocked = config.get_value("main", "endless_mode_unlocked", false)
	best_score = config.get_value("main", "best_score", 0 )
	config.save("user://save.cfg")

func save_progression() -> void:
	config.set_value("main", "endless_mode_unlocked", endless_mode_unlocked )
	config.set_value("main", "best_score", best_score )
	config.save("user://save.cfg")

func _ready() -> void:
	load_progression()
	print(best_score)


func reset_game(mode: Mode) -> void:
	score = 0
	controls_available = true
	game_mode = mode
	kms = 0
	bombs_count = 0

func set_score(s: int) -> void:
	score = s
	if score > best_score:
		best_score = score
	score_changed.emit(s)

func score_km() -> void:
	score += 1
	kms += 1

func score_bomb() -> void:
	score += 10
	bombs_count +=1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var window_mode := DisplayServer.window_get_mode()
		var is_window: bool = window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if is_window \
			else DisplayServer.WINDOW_MODE_WINDOWED)
