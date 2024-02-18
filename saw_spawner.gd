extends Area2D
class_name SawSpawner

enum State {
	Running,
	Stopped,
}

var _SAW_PRELOAD := preload("res://saw.tscn")

@onready var _collision_shape := $CollisionShape2D as CollisionShape2D

var _state = State.Running

func stop() -> void:
	_state = State.Stopped

func _spawn() -> void:
	if not Toggles.spawn_saws:
		return

	var saw := _SAW_PRELOAD.instantiate() as Saw
	var zone := _get_spawn_zone()
	saw.position = Vector2(
		randf_range(zone.position.x, zone.size.x),
		randf_range(zone.position.y, zone.size.y)
	)
	saw.initial_direction = _get_initial_direction()
	add_child(saw)

func _get_spawn_zone() -> Rect2:
	var res := Rect2(
		position + _collision_shape.position + _collision_shape.shape.get_rect().position, 
		_collision_shape.shape.get_rect().size)

	return res

func _get_initial_direction() -> Vector2:
	var res := Vector2.DOWN
	res += [
		Vector2.LEFT + Vector2(randf_range(0, 0.2), 0), 
		Vector2.RIGHT + Vector2(randf_range(-0.2, 0), 0)
	].pick_random() as Vector2
	return res

func _ready():
	pass

func _process(_delta):
	pass

func _on_timer_timeout():
	if _state == State.Running:
		_spawn()
