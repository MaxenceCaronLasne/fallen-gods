extends Node

@export var _actor: CharacterBody2D

var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	assert(_actor)

func _physics_process(delta: float):
	_actor.velocity.y += _gravity * delta
