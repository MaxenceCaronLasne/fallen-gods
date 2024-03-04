extends MovementState

signal jump_from_air
signal reached_apogea

enum State {
	Idle,
	Ascending,
	Falling,
}

@export var _jump_settings: JumpSettings

@export var _max_double_jump: int
@export var _lateral_speed: float

@onready var _nb_double_jump := _max_double_jump

var _current_state := State.Idle
var _was_falling_last_frame := false

func enter() -> void:
	_nb_double_jump = _max_double_jump
	_jump()

func exit() -> void:
	_current_state = State.Idle

func _jump() -> void:
	if _nb_double_jump <= 0:
		return

	_current_state = State.Ascending
	_actor.velocity.y = 0.0
	_actor.velocity.y += _jump_settings.get_velocity(true)
	jump_from_air.emit()
	_nb_double_jump -= 1

func _check_if_double_jumping() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump()

func _process_falling(delta: float) -> void:
	match _current_state:
		State.Ascending: _actor.velocity.y += _jump_settings.get_gravity(false) * delta
		State.Falling: _actor.velocity.y += _jump_settings.get_gravity(true) * delta

	var is_falling := _actor.velocity.y > 0
	if is_falling and not _was_falling_last_frame:
		reached_apogea.emit()
		_current_state = State.Falling

	_was_falling_last_frame = is_falling

func _process_lateral_move() -> void:
	var direction := Input.get_axis("left", "right")
	_actor.velocity.x = direction * _lateral_speed

func _process_break() -> void:
	if Input.is_action_just_released("jump") and _current_state == State.Ascending:
		_actor.velocity.y *= _jump_settings.get_jump_brake()

func _process(delta: float):
	if _current_state == State.Idle:
		return

	if _actor.is_on_floor() and _current_state == State.Falling:
		_on_touched_floor()
		return

	_check_if_double_jumping()
	_process_falling(delta)
	_process_lateral_move()
	_process_break()

func _on_touched_floor() -> void:
	_current_state = State.Idle
	exited.emit(MovementStateMachine.State.Move)
