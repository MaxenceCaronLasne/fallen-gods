extends Resource
class_name JumpSettings

@export var _max_height: float = 0.0 ## Maximum height of the jump
@export var _min_height: float = 0.0 ## Minimum height of the jump
@export var _duration: float = 0.0 ## Time to reach maximum height

var _gravity: float = 0.0
var _velocity: float = 0.0

var _already_computed: bool = false

func _compute() -> void:
	_gravity = -2.0 * _max_height / pow(_duration, 2.0) * -1.0
	_velocity = (2.0 * _max_height) / _duration * -1.0
	_already_computed = true
	print_debug(_gravity, "; ", _velocity)

func get_gravity() -> float:
	if not _already_computed:
		_compute()
	
	return _gravity

func get_velocity() -> float:
	if not _already_computed:
		_compute()
	
	return _velocity
