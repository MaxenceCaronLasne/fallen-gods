extends Node
class_name MoveComponent

enum MoveType {
	Fix,
	Slippy,
}

@export var _actor: CharacterBody2D
@export var _speed: float
@export var _max_speed: float
@export var _move_type: MoveType

var _is_accepting_input: bool = false

func accept_input() -> void:
	_is_accepting_input = true

func reject_input() -> void:
	_is_accepting_input = false

func touch_floor() -> void:
	_actor.velocity.x = 0.0

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

	if not _is_accepting_input:
		return

	var direction := Input.get_axis("left", "right")
	
	match _move_type:
		MoveType.Fix: _actor.velocity.x = _get_fixed_velocity(direction, delta)
		MoveType.Slippy: _actor.velocity.x = _get_slippy_velocity(direction, _actor.velocity.x, delta)
