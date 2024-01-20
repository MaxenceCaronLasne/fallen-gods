extends CharacterBody2D

signal just_touched_floor

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -250.0
@export var MAX_DOUBLE_JUMPS: int = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _nb_jumps: int = 0
var _touched_floor_last_frame := false

func _ready() -> void:
	just_touched_floor.connect(_on_just_touched_floor)

func _jump() -> void:
	if is_on_floor() or _nb_jumps > 0:
		_nb_jumps -= 1
		velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		_touched_floor_last_frame = false
	else:
		_nb_jumps = MAX_DOUBLE_JUMPS
		if not _touched_floor_last_frame:
			just_touched_floor.emit()
		_touched_floor_last_frame = true

	if Input.is_action_just_pressed("accept"):
		_jump()

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_just_touched_floor() -> void:
	print_debug("touched floor")
