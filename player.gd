extends CharacterBody2D

signal just_touched_floor
signal just_died

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -250.0
@export var MAX_DOUBLE_JUMPS: int = 20

@onready var _hitbox := $HitBox as Area2D

var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var _nb_jumps: int = 0
var _touched_floor_last_frame := false

func _ready() -> void:
	just_touched_floor.connect(_on_just_touched_floor)
	_hitbox.body_entered.connect(_on_hit_box_body_entered)

func _jump() -> void:
	if is_on_floor() or _nb_jumps > 0:
		_nb_jumps -= 1
		velocity.y = JUMP_VELOCITY

func _physics_process_on_floor(_delta: float) -> void:
	if not _touched_floor_last_frame:
		just_touched_floor.emit()
	_nb_jumps = MAX_DOUBLE_JUMPS
	_touched_floor_last_frame = true

func _physics_process_air(delta: float) -> void:
	velocity.y += _gravity * delta
	_touched_floor_last_frame = false

func _physics_process(delta: float):
	if is_on_floor():
		_physics_process_on_floor(delta)
	else:
		_physics_process_air(delta)

	if Input.is_action_just_pressed("accept"):
		_jump()

	var direction := Input.get_axis("left", "right")
	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
	
	move_and_slide()

func _on_just_touched_floor() -> void:
	get_tree().call_group("saws", "maybe_destroy")
	print_debug("touched floor")

func _on_hit_box_body_entered(_body):
	just_died.emit()
	queue_free()
	print_debug("touched!")
