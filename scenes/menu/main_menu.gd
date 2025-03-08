extends Control

@onready var start_button : Button = %StartButton
@onready var endless_button : Button = %EndlessButton
@onready var normal_button : Button = %NormalButton

@onready var best_run : Label = %BestRun

func _ready() -> void:
	start_button.pressed.connect(start.bind(Config.Mode.Normal))
	normal_button.pressed.connect(start.bind(Config.Mode.Normal))
	endless_button.pressed.connect(start.bind(Config.Mode.Endless))
	(%StartButton as Control).visible = !Config.endless_mode_unlocked
	(%EndlessSection as Control).visible = Config.endless_mode_unlocked
	if Config.endless_mode_unlocked:
		endless_button.grab_focus()
	else:
		start_button.grab_focus()

	if Config.best_score > 0:
		best_run.text = "Best Run: %dkm" % Config.best_score
	else:
		best_run.visible = false

func start(mode: Config.Mode) -> void:
		Config.reset_game(mode)
		SceneManager.go_to_game()
