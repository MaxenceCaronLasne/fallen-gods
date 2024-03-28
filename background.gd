extends Node2D
class_name Background

@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _animation_tree := $AnimationTree as AnimationTree

func die() -> void:
	var state_machine = _animation_tree["parameters/playback"] as AnimationNodeStateMachinePlayback
	state_machine.travel("dying")

func hit() -> void:
	_animation_player.play("hit")

func _ready():
	_animation_player.play("RESET")

func _process(_delta):
	pass
