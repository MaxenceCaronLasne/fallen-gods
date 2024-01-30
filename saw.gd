extends CharacterBody2D
class_name Saw

var initial_direction: Vector2 = Vector2.DOWN + Vector2.LEFT

@export var _speed: float = 40.0

var _is_touched: bool = false

func maybe_destroy() -> bool:
	if not _is_touched:
		return false
	
	queue_free()
	return true

func _move(delta: float) -> void:
	if _is_touched and Toggles.saw_stops_when_hovered:
		return

	var collision := move_and_collide(velocity * delta)
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())

func _ready():
	velocity = initial_direction * _speed

func _process(delta: float):
	_move(delta)

func _on_hit_box_body_entered(_body):
	modulate = Color.RED
	_is_touched = true
