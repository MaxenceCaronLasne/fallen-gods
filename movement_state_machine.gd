extends Node
class_name MovementStateMachine

enum State {
	Pause,
	Move,
	Jump,
	DoubleJump,
}

@export var _move_state_node: MovementState
@export var _jump_state_node: MovementState
@export var _double_jump_state_node: MovementState

var _current_state := State.Move

func start(new_state: State) -> void:
	_current_state = new_state
	
	match new_state:
		State.Move: _move_state_node.enter()
		State.Jump: _jump_state_node.enter()
		State.DoubleJump: _double_jump_state_node.enter()

func stop() -> void:
	match _current_state:
		State.Move: _move_state_node.exit()
		State.Jump: _jump_state_node.exit()
		State.DoubleJump: _double_jump_state_node.exit()

	_current_state = State.Pause

func _ready():
	_move_state_node.exited.connect(_on_state_exited)
	_jump_state_node.exited.connect(_on_state_exited)
	_double_jump_state_node.exited.connect(_on_state_exited)
	
	start(_current_state)

func _on_state_exited(next_state: State) -> void:
	await get_tree().process_frame
	start(next_state)
