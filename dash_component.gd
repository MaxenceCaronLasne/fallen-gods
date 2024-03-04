extends Node
class_name DashComponent

signal finished

enum State {
	NotDashing,
	PreDash,
	Dash,
	PostDash,
}

@export var _actor: CharacterBody2D
@export var _speed := 100.0

var _current_state := State.NotDashing
var _current_dir := Vector2.ZERO

func dash() -> void:
	_enter_pre_dash()

func _enter_not_dashing() -> void:
	_current_state = State.NotDashing

func _enter_pre_dash() -> void:
	_current_state = State.PreDash
	_current_dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")).normalized()
	await get_tree().create_timer(0.2).timeout
	_enter_dash()

func _enter_dash() -> void:
	_current_state = State.Dash
	await get_tree().create_timer(1.0).timeout
	_enter_post_dash()

func _enter_post_dash() -> void:
	_current_state = State.PostDash
	await get_tree().create_timer(0.2).timeout
	finished.emit()
	_enter_not_dashing()

func _ready():
	pass

func _process_dash() -> void:
	_actor.velocity = _current_dir * _speed

func _process(_delta: float) -> void:
	match _current_state:
		State.NotDashing: return
		State.PreDash: return
		State.Dash: _process_dash()
		State.PostDash: return
		_: assert(false, "invalid state")
