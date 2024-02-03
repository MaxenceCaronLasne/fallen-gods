extends Node
class_name ShakeComponent

signal ended_shaking

const NOISE_PICKER_SPEED: float = 500.0
const NOISE_AMP: float = 4.0
const SHAKE_RECOVERY_RATE: float = 5.0

@export var _actor: Node2D = null

var _initial_position: Vector2 = Vector2.ZERO
var _shake_factor: float = 0.0

var _noise_offset: float = 0.0
var _is_shaking: bool = false

@onready var _noise := FastNoiseLite.new()

func shake(intensity: float) -> void:
	_shake_factor += intensity
	_is_shaking = true

func _ready():
	assert(_actor)
	_initial_position = _actor.position
	EventBus.shake.connect(shake)

func _process(delta: float):
	if is_zero_approx(_shake_factor):
		if _is_shaking:
			_is_shaking = false
			ended_shaking.emit()
		return
	
	var offset_x := _noise.get_noise_2d(0, _noise_offset) * _shake_factor
	var offset_y := _noise.get_noise_2d(10, _noise_offset) * _shake_factor
	_noise_offset += NOISE_PICKER_SPEED * delta
	
	_actor.position = _initial_position + Vector2(offset_x, offset_y)
	
	_shake_factor = clampf(_shake_factor - (SHAKE_RECOVERY_RATE * delta), 0.0, INF)
