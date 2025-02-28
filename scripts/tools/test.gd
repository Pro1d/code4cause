@tool
extends EditorScript

enum E { AA, BB }

# Called when the node enters the scene tree for the first time.
func _run() -> void:
	prints(E.values(), E.keys())
	prints(E.AA, E.find_key(E.AA))
	prints(E.BB, E.find_key(E.BB))
