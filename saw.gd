extends CharacterBody2D

@export var INITIAL_DIRECTION: Vector2 = Vector2.DOWN + Vector2.LEFT
@export var SPEED: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = INITIAL_DIRECTION * SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())
