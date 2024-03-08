extends Node2D

@export var _currently_focus: StoreShelf

@onready var _cursor := $Cursor as Sprite2D
@onready var _move_sfxr_stream_player := $MoveSfxrStreamPlayer as AudioStreamPlayer
@onready var _buy_sfxr_stream_player := $BuySfxrStreamPlayer as AudioStreamPlayer
@onready var _failed_sfxr_stream_player := $FailedSfxrStreamPlayer as AudioStreamPlayer

func _ready():
	pass

func _maybe_focus(neighbor: StoreShelf) -> bool:
	if neighbor == null:
		return false

	_currently_focus = neighbor

	return true

func _update_cursor() -> void:
	_cursor.position = _currently_focus.position
	_move_sfxr_stream_player.play()

func _process(delta: float):
	if Input.is_action_just_pressed("left"):
		_maybe_focus(_currently_focus.neighbor_left)
		_update_cursor()
	if Input.is_action_just_pressed("right"):
		_maybe_focus(_currently_focus.neighbor_right)
		_update_cursor()
	if Input.is_action_just_pressed("jump"):
		if _currently_focus.maybe_buy():
			_buy_sfxr_stream_player.play()
			print_debug("try buying")
		else:
			_failed_sfxr_stream_player.play()
			print_debug("failed")
