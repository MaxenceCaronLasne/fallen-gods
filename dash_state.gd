extends MovementState

enum State {
	NotDashing,
	Dashing,
}

@export var _duration: float = 1.0

var _current_state := State.NotDashing
var _direction := Vector2.ZERO
var _speed := 40.0

func enter() -> void:
	_actor.velocity = Vector2.ZERO
	_current_state = State.Dashing
	
	_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	_actor.velocity = _direction * _speed
	
	await get_tree().create_timer(_duration).timeout
	_current_state = State.NotDashing
	exited.emit(MovementStateMachine.State.Move)

func _process(delta):
	if _current_state == State.NotDashing:
		return
	
	
