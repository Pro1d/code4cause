extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -950.0
const INITIAL_SPEED = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:     
		velocity.x = lerpf(velocity.x, 0, 0.01)

	move_and_slide()
