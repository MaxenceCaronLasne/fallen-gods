extends MovementState

signal started_walking
signal stopped_walking

enum State {
	NotOnFloor,
	OnFloor,
}

@export var _speed := 40.0
@export var _jump_settings: JumpSettings

var _current_state := State.NotOnFloor
var _was_walking_last_frame := false

func enter() -> void:
	_current_state = State.OnFloor

func exit() -> void:
	_current_state = State.NotOnFloor

func _exit() -> void:
	exit()

	if _was_walking_last_frame:
		stopped_walking.emit()
		_was_walking_last_frame = false

	exited.emit(MovementStateMachine.State.Jump)

func _check_walking(direction: float) -> void:
	if is_zero_approx(direction) and _was_walking_last_frame:
		stopped_walking.emit()
		_was_walking_last_frame = false

	if not is_zero_approx(direction) and not _was_walking_last_frame:
		started_walking.emit()
		_was_walking_last_frame = true

func _process_movement(delta: float) -> void:
	if not _actor.is_on_floor():
		_actor.velocity.y += _jump_settings.get_gravity(true) * delta
		return

	if Input.is_action_just_pressed("jump"):
		_exit()
		return

	_actor.velocity.x = 0.0

	var direction := Input.get_axis("left", "right")

	_check_walking(direction)
	_actor.velocity.x = direction * _speed

func _process(delta: float):
	match _current_state:
		State.NotOnFloor: return
		State.OnFloor: _process_movement(delta)
