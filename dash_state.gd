extends MovementState

enum State {
	NotDashing,
	Dashing,
}

@export var _duration: float = 0.2
@export var _speed := 300.0

var _current_state := State.NotDashing
var _direction := Vector2.ZERO

func enter() -> void:
	_actor.velocity = Vector2.ZERO
	_current_state = State.Dashing
	
	_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	_actor.velocity = _direction * _speed
	_actor.add_invuln_time(_duration + 0.2)
	
	await get_tree().create_timer(_duration).timeout
	
	_actor.velocity = Vector2.ZERO
	_current_state = State.NotDashing
	exited.emit(MovementStateMachine.State.Move)

func _process(delta):
	if _current_state == State.NotDashing:
		return
	
	
