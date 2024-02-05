extends CharacterBody2D
class_name Saw

const BAD_COLOR := Color8(231, 126, 200)

var initial_direction: Vector2 = Vector2.DOWN + Vector2.LEFT

@export var _speed: float = 40.0

@onready var _animation_tree := $AnimationTree as AnimationTree
@onready var _spirte := $Sprite2D as Sprite2D
@onready var _collision_shape := $CollisionShape2D as CollisionShape2D
@onready var _pop_gfx := $PopGfx as AnimatedSprite2D

var _is_touched: bool = false
var _is_dead: bool = false

func maybe_destroy() -> bool:
	if not _is_touched:
		return false

	if _is_dead:
		return false

	_animation_tree.set("parameters/ShotDie/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	_is_dead = true
	_collision_shape.disabled = true
	EventBus.shake.emit(1.0)
	EventBus.saw_destroyed.emit()
	return true

func _has_just_touched_floor(collision: KinematicCollision2D) -> bool:
	return collision.get_normal().is_equal_approx(Vector2.UP)

func _move(delta: float) -> void:
	if _is_touched and Toggles.saw_stops_when_hovered:
		return

	var collision := move_and_collide(velocity * delta)

	if collision == null:
		return

	velocity = velocity.bounce(collision.get_normal())

	if _has_just_touched_floor(collision):
		_on_just_touched_floor()

func _ready():
	velocity = initial_direction * _speed

func _process(delta: float):
	if _is_dead:
		return
	_move(delta)

func _on_hit_box_body_entered(_body):
	if _is_dead:
		return
	_spirte.modulate = BAD_COLOR
	_is_touched = true
	_animation_tree.set("parameters/ShotSelect/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	_pop_gfx.play("pop")


func _on_just_touched_floor():
	if _is_dead:
		return
	_animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
