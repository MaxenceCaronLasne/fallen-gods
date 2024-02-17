extends CharacterBody2D

enum State {
	Idle,
	Walk,
	Up,
	Down,
	Land,
	Pause,
	Fall,
	Crash,
}

signal just_touched_floor
signal just_died
signal finished_dying

@onready var _hitbox := $HitBox as Area2D
@onready var _on_floor_notifier := $OnFloorNotifier as OnFloorNotifier
@onready var _jump_component := $JumpComponent as JumpComponent
@onready var _move_component := $MoveComponent as MoveComponent
@onready var _animated_sprite := $Sprite2D as AnimatedSprite2D

var _state: State = State.Idle

func _enter_idle() -> void:
	_state = State.Idle
	_animated_sprite.play("idle")
	_jump_component.accept_input()
	_move_component.accept_input()

func _enter_walk() -> void:
	_state = State.Walk
	_animated_sprite.play("walk")

func _enter_up() -> void:
	_state = State.Up
	_animated_sprite.play("up")

func _enter_down() -> void:
	_state = State.Down
	_animated_sprite.play("down")

func _enter_land() -> void:
	_state = State.Land
	get_tree().call_group("saws", "maybe_destroy")
	_jump_component.touch_floor()
	_move_component.touch_floor()
	_animated_sprite.play("land")
	await _animated_sprite.animation_finished
	_enter_idle()

func _enter_pause() -> void:
	_state = State.Pause
	_animated_sprite.pause()
	_jump_component.process_mode = Node.PROCESS_MODE_DISABLED
	_move_component.process_mode = Node.PROCESS_MODE_DISABLED

	velocity = Vector2.ZERO
	just_died.emit()
	EventBus.shake.emit(2.0)
	await get_tree().create_timer(0.3).timeout
	_enter_fall()

func _enter_fall() -> void:
	_state = State.Fall
	_animated_sprite.play("fall")

	if is_on_floor():
		await _animated_sprite.animation_finished
		_enter_crash()

func _enter_crash() -> void:
	_state = State.Crash
	EventBus.shake.emit(2.0)
	_animated_sprite.play("crash")
	finished_dying.emit()

func _ready() -> void:
	_hitbox.body_entered.connect(_on_hit_box_body_entered)
	_on_floor_notifier.just_touched_floor.connect(
		_on_floor_notifier_just_touched_floor)
	_enter_idle()

func _physics_process_dying(delta: float) -> void:
	velocity += Vector2(0, 40) * delta
	move_and_slide()

func _physics_process(delta: float):
	match _state:
		State.Fall: _physics_process_dying(delta)
		State.Crash: _physics_process_dying(delta)
		_: move_and_slide()

func _on_hit_box_body_entered(_body):
	match _state:
		State.Pause: return
		State.Fall: return
		State.Crash: return
		_: _enter_pause()

func _on_floor_notifier_just_touched_floor():
	match _state:
		State.Down: _enter_land()
		State.Fall: _enter_crash()
		State.Idle: pass # Falling when game starts
		_: push_warning("touched floor in unprocessed state: ", _state)

	just_touched_floor.emit()

func _on_jump_component_jump_from_ground() -> void:
	match _state:
		State.Idle: _enter_up()
		State.Walk: _enter_up()
		State.Land: _enter_up()
		_: push_warning("jump from ground in unprocessed state: ", _state)

func _on_jump_component_reached_apogea() -> void:
	match _state:
		State.Idle: pass # Falling when game starts
		State.Up: _enter_down()
		_: push_warning("reached apogea in unprocessed state: ", _state)

func _on_move_component_started_walking() -> void:
	match _state:
		State.Idle: _enter_walk()
		State.Up: pass
		State.Land: pass
		_: push_warning("started walking from unprocessed state: ", _state)

func _on_move_component_stopped_walking() -> void:
	match _state:
		State.Idle: pass
		State.Walk: _enter_idle()
		State.Up: pass # Stop walking when jumping
		State.Down: pass
		State.Land: pass
		_: push_warning("stopped walking from unprocessed state: ", _state)

func _on_jump_component_jump_from_air():
	match _state:
		State.Up: _enter_up()
		State.Down: _enter_up()
