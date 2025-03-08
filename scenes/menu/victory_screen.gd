extends Control

@onready var start_button : Button = %Start
@onready var gomain_button : Button = %GoMain
@onready var score : Label = %Score
@onready var best_run : Label = %BestRun
@onready var toast : Control = %Toast

func _ready() -> void:
	if not Config.endless_mode_unlocked:
		Config.endless_mode_unlocked = true
		_show_endless_mode_unlocked()
	else:
		toast.visible = false
	Config.save_progression()
	gomain_button.grab_focus()
	gomain_button.pressed.connect(SceneManager.go_to_main_menu)
	score.text = "Score: %dkm" % Config.score
	if Config.best_score > 0:
		if Config.best_score == Config.score:
			best_run.text = "New Record!"
		else:
			best_run.text = "Best Run: %dkm" % Config.best_score
	else:
		best_run.visible = false

func _show_endless_mode_unlocked()->void:
	var viewport_rect := get_viewport_rect().size
	toast.position.y = viewport_rect.y + toast.get_rect().size.y
	toast.position.x = viewport_rect.x/2 - toast.get_rect().size.x /2
	var tween := get_tree().create_tween()
	tween.tween_interval(0.25)
	tween.tween_property(toast, "position:y", viewport_rect.y - toast.get_rect().size.y - 16, 0.25)
	tween.tween_interval(4)
	tween.tween_property(toast, "position:y", viewport_rect.y + toast.get_rect().size.y, 0.25)
