extends Resource
class_name JumpSettings

@export var _max_height: float = 0.0 ## Maximum height of the jump
@export var _min_height: float = 0.0 ## Minimum height of the jump
@export var _peak_duration: float = 0.0 ## Time to reach maximum height
@export var _fall_duration: float = 0.0 ## Time to reach ground after reaching the apogea

var _peak_gravity: float = 0.0
var _fall_gravity: float = 0.0
var _velocity: float = 0.0

var _already_computed: bool = false

func _compute() -> void:
	_peak_gravity = -2.0 * _max_height / pow(_peak_duration, 2.0) * -1.0
	_fall_gravity = -2.0 * _max_height / pow(_fall_duration, 2.0) * -1.0
	_velocity = (2.0 * _max_height) / _peak_duration * -1.0
	_already_computed = true

func get_gravity(is_falling: bool = false) -> float:
	if not _already_computed:
		_compute()
	
	return _fall_gravity if is_falling else _peak_gravity

func get_velocity() -> float:
	if not _already_computed:
		_compute()
	
	return _velocity
