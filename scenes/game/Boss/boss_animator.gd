class_name BossAnimator
extends AnimationTree

func idle() -> void:
	reset_state()
	set("Parameters/Conditions/Idle", true)
	
func damage() -> void:
	reset_state()
	set("Parameters/Conditions/Damage", true)
	
func death() -> void:
	reset_state()
	set("Parameters/Conditions/Death", true)

func reset_state() -> void:
	set("Parameters/Conditions/Idle", false)
	set("Parameters/Conditions/Damage", false)
	set("Parameters/Conditions/Death", false)
