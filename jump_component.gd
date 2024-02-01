extends Node
class_name JumpComponent

enum JumpType {NONE, FROM_GROUND, FROM_AIR}

@export var _actor: CharacterBody2D
@export var _input_jump: String = "jump"
@export var _jump_settings: JumpSettings = null

var _current_jump_type: JumpType = JumpType.NONE

var _touched_floor_last_frame: bool = false

func touch_floor() -> void:
	_on_touched_floor()

func _process_gravity(delta: float) -> void:
	var is_falling := _actor.velocity.y > 0
	var gravity := _jump_settings.get_gravity(is_falling) * delta
	_actor.velocity.y += gravity # Velocity in pixel per second

func _process_jump(_delta: float) -> void:
	if Input.is_action_just_pressed(_input_jump) and _current_jump_type == JumpType.NONE:
		_actor.velocity.y = _jump_settings.get_velocity()
		_current_jump_type = JumpType.FROM_GROUND

func _physics_process(delta: float):
	_process_gravity(delta)
	_process_jump(delta)

func _on_touched_floor() -> void:
	_current_jump_type = JumpType.NONE
