extends CharacterBody2D

signal just_touched_floor
signal just_died
signal finished_dying

@onready var _hitbox := $HitBox as Area2D
@onready var _on_floor_notifier := $OnFloorNotifier as OnFloorNotifier
@onready var _jump_component := $JumpComponent as JumpComponent
@onready var _move_component := $MoveComponent as MoveComponent
@onready var _animation_player := $AnimationPlayer as AnimationPlayer

var _is_dead: bool = false

func _ready() -> void:
	_hitbox.body_entered.connect(_on_hit_box_body_entered)
	_on_floor_notifier.just_touched_floor.connect(
		_on_floor_notifier_just_touched_floor)
	_jump_component.accept_input()
	_move_component.accept_input()

func _physics_process(_delta: float):
	move_and_slide()

func _on_hit_box_body_entered(_body):
	if _is_dead:
		return

	_is_dead = true
	just_died.emit()
	_animation_player.play("die")
	_jump_component.reject_input()
	_move_component.reject_input()

func _on_floor_notifier_just_touched_floor():
	get_tree().call_group("saws", "maybe_destroy")
	_jump_component.touch_floor()
	_move_component.touch_floor()
	just_touched_floor.emit()
