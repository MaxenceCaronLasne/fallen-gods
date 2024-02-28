extends Node2D
class_name SawSpawner

enum State {
	Idle,
	Running,
	Stopped,
}

@export var _left_spawner: Marker2D
@export var _middle_spawner: Marker2D
@export var _right_spawner: Marker2D

@onready var _left_spawner_position := _left_spawner.global_position
@onready var _middle_spawner_position := _middle_spawner.global_position
@onready var _right_spawner_position := _right_spawner.global_position
@onready var _timer := $Timer as Timer

var _SAW_PRELOAD := preload("res://saw.tscn")

var _state = State.Idle

func stop() -> void:
	_state = State.Stopped

func run(pattern: SpawnPattern) -> void:
	print_debug("run: ", pattern)
	_state = State.Running
	for action in pattern.actions:
		print_debug("action")
		await _process_action(action)
	_state = State.Idle
	_timer.start()

func _get_spawn_position(action_position: SpawnAction.SpawnPosition) -> Vector2:
	match action_position:
		SpawnAction.SpawnPosition.Left: return _left_spawner_position
		SpawnAction.SpawnPosition.Middle: return _middle_spawner_position
		SpawnAction.SpawnPosition.Right: return _right_spawner_position
		SpawnAction.SpawnPosition.Random:
			return [
				_left_spawner_position,
				_middle_spawner_position,
				_right_spawner_position
			].pick_random() as Vector2
		_: 
			assert(false)
			return Vector2.ZERO

func _process_action(action: SpawnAction) -> void:
	var saw := _SAW_PRELOAD.instantiate() as Saw
	saw.global_position = _get_spawn_position(action.position)
	saw.initial_direction = Vector2.DOWN.rotated(deg_to_rad(action.angle))
	add_child(saw)
	await get_tree().create_timer(action.then_wait).timeout

func _ready() -> void:
	pass

func _on_timer_timeout():
	print_debug("timeout")
	if not _state == State.Idle:
		print_debug("ho?")
		return
	print_debug("waa")
	run(SpawnPattern.get_random_pattern())
