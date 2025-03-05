extends Control

@onready var start_button : Button = %Start
@onready var gomain_button : Button = %GoMain
@onready var score : Label = %Score
@onready var best_run : Label = %BestRun

func _ready() -> void:
	start_button.pressed.connect(restart)
	gomain_button.pressed.connect(SceneManager.go_to_main_menu)
	score.text = "Score: %dkm" % Config.score
	if Config.best_score > 0:
		if Config.best_score == Config.score:
			best_run.text = "New Record!"
		else:
			best_run.text = "Best Run: %dkm" % Config.best_score
	else:
		best_run.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		restart()
		
func restart() -> void:
		Config.reset_game()
		SceneManager.go_to_game()
