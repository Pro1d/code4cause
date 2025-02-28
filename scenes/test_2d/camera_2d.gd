extends Camera2D


var offset_x := 0
func _ready() -> void:
	offset_x = global_position.x - (%Player as Node2D).global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if((%Player as Node2D).global_position.x + offset_x > global_position.x):
		global_position.x = (%Player as Node2D).global_position.x + offset_x
