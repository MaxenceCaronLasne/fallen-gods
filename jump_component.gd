extends Node

class Jump:
	var total_impulse: float = 0.0
	var nb_jump: int = 1

@export var _actor: CharacterBody2D
@export var _initial_impulse: float
@export var _continuous_impulse: float
@export var _max_impulse: float
@export var _fall_added_gravity: float = 0.0
@export var _max_nb_jumps: int

var _current_jump: Jump = null

func _jump(delta: float) -> void:
	if _current_jump == null:
		_current_jump = Jump.new()
	else:
		_current_jump.total_impulse = 0.0
		_current_jump.nb_jump += 1

	if _current_jump.nb_jump > _max_nb_jumps:
		return

	_actor.velocity.y = 0.0

	_current_jump.total_impulse += _initial_impulse * delta
	_actor.velocity.y -= _initial_impulse * delta

func _continue_jump(delta: float) -> void:
	if _current_jump == null:
		return
	
	if _current_jump.total_impulse + _continuous_impulse * delta < _max_impulse:
		_current_jump.total_impulse += _continuous_impulse * delta
		_actor.velocity.y -= _continuous_impulse * delta

func _add_gravity(delta: float) -> void:
	if _actor.velocity.y > 0:
		_actor.velocity.y += _fall_added_gravity * delta

func _ready():
	assert(_actor)

func _physics_process(delta: float) -> void:
	if _actor.is_on_floor() and _current_jump != null:
		_current_jump = null

	if Input.is_action_just_pressed("accept"):
		_jump(delta)
	elif Input.is_action_pressed("accept"):
		_continue_jump(delta)
	
	_add_gravity(delta)
