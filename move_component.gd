extends Node
class_name MoveComponent

signal started_walking
signal stopped_walking

enum MoveType {
	Fix,
	Slippy,
}

@export var _actor: CharacterBody2D
@export var _speed: float
@export var _max_speed: float
@export var _move_type: MoveType

var _is_accepting_input: bool = false
var _is_walking: bool = false
var _was_walking_last_frame: bool = false

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
	_is_walking = false

	if not _actor.is_on_floor() or not _is_accepting_input:
		if _was_walking_last_frame:
			stopped_walking.emit()
		_was_walking_last_frame = false
		return

	var direction := Input.get_axis("left", "right")

	if not is_zero_approx(direction):
		if not _was_walking_last_frame:
			started_walking.emit()
		_was_walking_last_frame = true
	else:
		if _was_walking_last_frame:
			stopped_walking.emit()
			_was_walking_last_frame = false

	match _move_type:
		MoveType.Fix: _actor.velocity.x = _get_fixed_velocity(direction, delta)
		MoveType.Slippy: _actor.velocity.x = _get_slippy_velocity(direction, _actor.velocity.x, delta)
