extends Node
class_name MovementState

signal exited(next_state: MovementStateMachine)

@export var _actor: CharacterBody2D

func enter() -> void:
	pass

func exit() -> void:
	pass

func _ready() -> void:
	assert(_actor)
