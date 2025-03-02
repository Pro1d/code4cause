class_name BossAnimator
extends AnimationTree

func idle() -> void:
	(self["parameters/playback"] as AnimationNodeStateMachinePlayback).travel("boss_idle")
	
func damage() -> void:
	(self["parameters/playback"] as AnimationNodeStateMachinePlayback).travel("boss_damage")
	
func death() -> void:
	(self["parameters/playback"] as AnimationNodeStateMachinePlayback).travel("boss_death")
