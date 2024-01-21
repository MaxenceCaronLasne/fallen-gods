extends CharacterBody2D
class_name Saw

@export var INITIAL_DIRECTION: Vector2 = Vector2.DOWN + Vector2.LEFT
@export var SPEED: float = 40.0

var _is_touched: bool = false

func maybe_destroy() -> bool:
	if not _is_touched:
		return false
	
	queue_free()
	return true

func _ready():
	velocity = INITIAL_DIRECTION * SPEED

func _process(delta):
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())

func _on_hit_box_body_entered(_body):
	print_debug("hello!")
	modulate = Color.RED
	_is_touched = true
