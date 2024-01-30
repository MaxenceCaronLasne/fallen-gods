extends Area2D
class_name SawSpawner

var SAW_PRELOAD := preload("res://saw.tscn")

@onready var _collision_shape := $CollisionShape2D as CollisionShape2D
@onready var _timer := $Timer as Timer

func spawn() -> void:
	if not Toggles.spawn_saws:
		return
	var saw := SAW_PRELOAD.instantiate() as Saw
	saw.position = Vector2(
		randf_range(0, _collision_shape.shape.get_rect().size.x - 1),
		randf_range(0, _collision_shape.shape.get_rect().size.y - 1))
	saw.initial_direction = _get_initial_direction()
	add_child(saw)

func _get_initial_direction() -> Vector2:
	var res := Vector2.DOWN
	res += [
		Vector2.LEFT + Vector2(randf_range(0, 0.2), 0), 
		Vector2.RIGHT + Vector2(randf_range(-0.2, 0), 0)
	].pick_random() as Vector2
	return res

func _ready():
	_timer.timeout.connect(spawn)

func _process(_delta):
	pass
