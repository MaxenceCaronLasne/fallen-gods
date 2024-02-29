extends RigidBody2D
class_name Coin

@export var _impulse_force := 200.0

@onready var _pop_gfx := $ParticlesSprite2D as AnimatedSprite2D
@onready var _sprite_2d := $Sprite2D as Sprite2D

func pick() -> void:
	EventBus.coin_picked.emit()
	_pop_gfx.play("pop")
	_sprite_2d.visible = false
	_pop_gfx.visible = true
	
	await _pop_gfx.animation_finished
	
	queue_free()

func _ready():
	apply_central_impulse(Vector2.UP.rotated(deg_to_rad(randi_range(-20, 20))) * _impulse_force)

func _process(_delta):
	pass
