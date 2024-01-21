extends CharacterBody2D
class_name Saw

@export var INITIAL_DIRECTION: Vector2 = Vector2.DOWN + Vector2.LEFT
@export var SPEED: float = 40.0

func _ready():
	velocity = INITIAL_DIRECTION * SPEED

func _process(delta):
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())
