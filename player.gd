extends CharacterBody2D
class_name Player

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
signal just_hit
signal finished_dying

@onready var _hitbox := $HitBox as Area2D
@onready var _on_floor_notifier := $OnFloorNotifier as OnFloorNotifier
@onready var _jump_component := $JumpComponent as JumpComponent
@onready var _move_component := $MoveComponent as MoveComponent
@onready var _animated_sprite := $Sprite2D as AnimatedSprite2D

@onready var _jump_from_ground_audio_player := $JumpFromGroundSfxrStreamPlayer as AudioStreamPlayer
@onready var _jump_from_air_audio_player := $JumpFromAirSfxrStreamPlayer as AudioStreamPlayer
@onready var _land_audio_player := $LandSfxrStreamPlayer as AudioStreamPlayer
@onready var _hurt_audio_player := $HurtSfxrStreamPlayer as AudioStreamPlayer
@onready var _die_audio_player := $DieSfxrStreamPlayer as AudioStreamPlayer

var _is_invuln: bool = false

var _state: State = State.Idle :
	set(value):
		_state = value

func die() -> void:
	_enter_pause()

func _hit() -> void:
	if _state == State.Pause or _state == State.Fall or _state == State.Crash:
		return

	_animated_sprite.modulate.a = 0.5
	_is_invuln = true
	just_hit.emit()
	print_debug("hit")
	_hurt_audio_player.play()

	await get_tree().create_timer(1.0).timeout

	_is_invuln = false
	_animated_sprite.modulate.a = 1.0

func _enter_idle() -> void:
	_state = State.Idle
	_animated_sprite.play("idle")
	_jump_component.accept_input()
	_move_component.accept_input()

func _enter_walk() -> void:
	_state = State.Walk
	_animated_sprite.play("walk")

func _enter_up(is_from_ground: bool) -> void:
	_state = State.Up
	_animated_sprite.play("up")
	if is_from_ground:
		_jump_from_ground_audio_player.pitch_scale = randf_range(0.90, 1.10)
		_jump_from_ground_audio_player.play()
	else:
		_jump_from_ground_audio_player.stop()
		_jump_from_air_audio_player.pitch_scale = randf_range(0.80, 1.00)
		_jump_from_air_audio_player.play()

func _enter_down() -> void:
	_state = State.Down
	_animated_sprite.play("down")

func _enter_land() -> void:
	_state = State.Land
	just_touched_floor.emit()
	_jump_component.touch_floor()
	_move_component.touch_floor()
	_animated_sprite.play("land")
	_land_audio_player.play()
	await _animated_sprite.animation_finished
	if _state == State.Land:
		_enter_idle()

func _enter_pause() -> void:
	_state = State.Pause
	_animated_sprite.modulate.a = 1.0
	_animated_sprite.pause()
	_jump_component.process_mode = Node.PROCESS_MODE_DISABLED
	_move_component.process_mode = Node.PROCESS_MODE_DISABLED

	_die_audio_player.play()

	velocity = Vector2.ZERO
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
	_land_audio_player.play()
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

func _on_hit_box_body_entered(body: Saw):
	if _is_invuln:
		return

	match _state:
		State.Pause: return
		State.Fall: return
		State.Crash: return
		_:
			body.destroy()
			_hit()

func _on_floor_notifier_just_touched_floor():
	match _state:
		State.Down: _enter_land()
		State.Fall: _enter_crash()
		State.Idle: pass # Falling when game starts
		_: push_warning("touched floor in unprocessed state: ", _state)

	just_touched_floor.emit()

func _on_jump_component_jump_from_ground() -> void:
	match _state:
		State.Idle: _enter_up(true)
		State.Walk: _enter_up(true)
		State.Land: _enter_up(true)
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
		State.Up: _enter_up(false)
		State.Down: _enter_up(false)

func _on_coin_box_body_entered(body):
	var coin := body as Coin
	coin.pick()
