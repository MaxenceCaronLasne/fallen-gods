extends Node

@export var _actor: CharacterBody2D
@export var _speed: float
@export var _max_speed: float

func _ready():
	assert(_actor)

func _process(delta: float):
	var direction := Input.get_axis("left", "right")
	_actor.velocity.x = move_toward(
		_actor.velocity.x, direction * _max_speed, _speed * delta)
