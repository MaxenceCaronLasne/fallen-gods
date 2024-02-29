extends RigidBody2D
class_name Coin

@export var _impulse_force := 200.0

func pick() -> void:
	EventBus.coin_picked.emit()
	queue_free()

func _ready():
	apply_central_impulse(Vector2.UP.rotated(deg_to_rad(randi_range(-20, 20))) * _impulse_force)

func _process(_delta):
	pass
