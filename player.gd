extends CharacterBody2D

signal just_touched_floor
signal just_died
signal finished_dying

@onready var _hitbox := $HitBox as Area2D
@onready var _on_floor_notifier := $OnFloorNotifier as OnFloorNotifier
@onready var _jump_component := $JumpComponent as JumpComponent
@onready var _move_component := $MoveComponent as MoveComponent
@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _animated_sprite := $Sprite2D as AnimatedSprite2D

var _is_dead: bool = false
var _has_reach_apogea: bool = false

func _ready() -> void:
	_hitbox.body_entered.connect(_on_hit_box_body_entered)
	_on_floor_notifier.just_touched_floor.connect(
		_on_floor_notifier_just_touched_floor)
	_jump_component.accept_input()
	_move_component.accept_input()

func _process(delta: float) -> void:
	pass

func _physics_process(_delta: float):
	if _is_dead:
		velocity = velocity / Vector2(1.2, 1.5)
	move_and_slide()

func _on_hit_box_body_entered(_body):
	if _is_dead:
		return

	_is_dead = true
	just_died.emit()
	EventBus.shake.emit(2.0)
	#_animation_player.play("die")
	_animated_sprite.play("fall")
	_jump_component.reject_input()
	_move_component.reject_input()

	if is_on_floor():
		await _animated_sprite.animation_finished
		_crash()

func _crash() -> void:
	EventBus.shake.emit(2.0)
	_animated_sprite.play("crash")
	finished_dying.emit()

func _on_floor_notifier_just_touched_floor():
	get_tree().call_group("saws", "maybe_destroy")
	_jump_component.touch_floor()
	_move_component.touch_floor()

	_has_reach_apogea = false

	if not _is_dead:
		_animated_sprite.play("land")
		await _animated_sprite.animation_finished
		_animated_sprite.play("idle")
	else:
		_crash()

	just_touched_floor.emit()

func _on_jump_component_jump_from_ground() -> void:
	_animated_sprite.play("up")

func _on_jump_component_reached_apogea() -> void:
	if not _has_reach_apogea:
		return

	_animated_sprite.play("down")
	_has_reach_apogea = true

func _on_move_component_started_walking() -> void:
	print_debug("started_walking: ", _animated_sprite.animation)
	if not _animated_sprite.animation == "idle":
		await _animated_sprite.animation_finished
	_animated_sprite.play("walk")


func _on_move_component_stopped_walking() -> void:
	print_debug("stopped_walking")
	if is_on_floor():
		_animated_sprite.play("idle")
