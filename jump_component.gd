extends Node
class_name JumpComponent

signal jump_from_ground
signal jump_from_air
signal reached_apogea

enum JumpType {NONE, FROM_GROUND, FROM_AIR}

@export var _actor: CharacterBody2D
@export var _input_jump: String = "jump"
@export var _jump_settings: JumpSettings = null
@export var _lateral_speed: float = 0.0
@export var _nb_of_double_jumps := 2

var _current_jump_type: JumpType = JumpType.NONE
var _is_accepting_input: bool = false
var _was_falling_last_frame: bool = false

@onready var _current_nb_double_jump := _nb_of_double_jumps

func accept_input() -> void:
	_is_accepting_input = true

func reject_input() -> void:
	_is_accepting_input = false

func touch_floor() -> void:
	_on_touched_floor()

func is_falling() -> bool:
	return _actor.velocity.y > 0

func _process_apogea() -> void:
	var i_f := is_falling()

	if i_f and not _was_falling_last_frame:
		reached_apogea.emit()

	_was_falling_last_frame = i_f

func _process_gravity(delta: float) -> void:
	var gravity := _jump_settings.get_gravity(is_falling()) * delta
	_actor.velocity.y += gravity # Velocity in pixel per second

func _process_lateral_move() -> void:
	if _actor.is_on_floor():
		return

	if not _is_accepting_input:
		return

	var direction := Input.get_axis("left", "right")

	_actor.velocity.x = direction * _lateral_speed

func _process_ground_jump() -> void:
	_actor.velocity.y = _jump_settings.get_velocity()
	_current_jump_type = JumpType.FROM_GROUND
	jump_from_ground.emit()

func _process_air_jump() -> void:
	if _current_nb_double_jump <= 0:
		return

	var is_double_jump := true
	_actor.velocity.y = _jump_settings.get_velocity(is_double_jump)
	_current_jump_type = JumpType.FROM_AIR
	jump_from_air.emit()
	_current_nb_double_jump -= 1

func _process_jump(_delta: float) -> void:
	if not _is_accepting_input:
		return

	if Input.is_action_just_pressed(_input_jump):
		match _current_jump_type:
			JumpType.NONE: _process_ground_jump()
			JumpType.FROM_GROUND, JumpType.FROM_AIR: _process_air_jump()

	if Input.is_action_just_released(_input_jump) and not is_falling():
		match _current_jump_type:
			JumpType.FROM_GROUND, JumpType.FROM_AIR:
				_actor.velocity.y *= _jump_settings.get_jump_brake()

func _physics_process(delta: float):
	_process_gravity(delta)
	_process_jump(delta)
	_process_lateral_move()
	_process_apogea()

func _on_touched_floor() -> void:
	_current_jump_type = JumpType.NONE
	_current_nb_double_jump = _nb_of_double_jumps
