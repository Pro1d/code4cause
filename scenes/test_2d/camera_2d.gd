extends Camera2D


var offset_x := 0
var offset_y := 0
func _ready() -> void:
	offset_x = global_position.x - (%Player as Node2D).global_position.x
	offset_y = global_position.y - (%Player as Node2D).global_position.y

func _process(_delta: float) -> void:
	if((%Player as Node2D).global_position.x + offset_x > global_position.x):
		global_position.x = (%Player as Node2D).global_position.x + offset_x
	
	var target_y: float = 370
	print((%Player as Node2D).global_position.y)
	if (%Player as Node2D).global_position.y < 200:
		target_y = 070
	
	global_position.y = lerpf(global_position.y, target_y, 0.01)
