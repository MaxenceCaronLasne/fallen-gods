extends Node

enum MoveType {
	Fix,
	Slippy,
}

@export var _actor: CharacterBody2D
@export var _speed: float
@export var _max_speed: float
@export var _move_type: MoveType

func _ready():
	assert(_actor)

func _get_fixed_velocity(direction: float, delta: float) -> float:
	return direction * _max_speed * delta

func _get_slippy_velocity(direction: float, initial_velocity: float, delta: float) -> float:
	var res := move_toward(
		initial_velocity,
		direction * _max_speed, 
		_speed * delta)
	return res

func _process(delta: float):
	if not _actor.is_on_floor():
		return

	var direction := Input.get_axis("left", "right")
	
	match _move_type:
		MoveType.Fix: _actor.velocity.x = _get_fixed_velocity(direction, delta)
		MoveType.Slippy: _actor.velocity.x = _get_slippy_velocity(direction, _actor.velocity.x, delta)
