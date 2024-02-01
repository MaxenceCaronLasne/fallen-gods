extends Resource
class_name JumpSettings

## Coef multiplying velocity when jump button is released. [br]
## x --> 0.0: more and more violent braking. [br]
## x --> 1.0: more and more loose braking. [br]
@export_range(0.0, 1.0) var _jump_brake: float = 0.0

@export_group("Jump from ground")
@export var _max_height: float = 0.0 ## Maximum height of the jump.
@export var _peak_duration: float = 0.0 ## Time to reach maximum height.
@export var _fall_duration: float = 0.0 ## Time to reach ground after reaching the apogea.

@export_group("Double jump")
@export var _double_jump_max_height: float = 0.0 ## Maximum height of double jumps

var _peak_gravity: float = 0.0
var _fall_gravity: float = 0.0
var _velocity: float = 0.0
var _double_jump_velocity: float = 0.0

var _already_computed: bool = false

func _compute() -> void:
	_peak_gravity = -2.0 * _max_height / pow(_peak_duration, 2.0) * -1.0
	_fall_gravity = -2.0 * _max_height / pow(_fall_duration, 2.0) * -1.0
	_velocity = (2.0 * _max_height) / _peak_duration * -1.0
	_double_jump_velocity = (2.0 * _double_jump_max_height) / _peak_duration * -1.0
	_already_computed = true

func get_gravity(is_falling: bool = false) -> float:
	if not _already_computed:
		_compute()

	if is_falling:
		return _fall_gravity
	else:
		return _peak_gravity

func get_velocity(is_double_jump: bool = false) -> float:
	if not _already_computed:
		_compute()
	
	if is_double_jump:
		return _double_jump_velocity
	else:
		return _velocity

func get_jump_brake() -> float:
	return _jump_brake
