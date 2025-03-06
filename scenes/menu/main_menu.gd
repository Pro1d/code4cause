extends Control

@onready var start_button : Button = %StartButton
@onready var best_run : Label = %BestRun

func _ready() -> void:
	start_button.pressed.connect(start)
	if Config.best_score > 0:
		best_run.text = "Best Run: %dkm" % Config.best_score
	else:
		best_run.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start()

func start() -> void:
		Config.reset_game()
		SceneManager.go_to_game()
