extends Node2D

@export var _currently_focus: StoreShelf

@onready var _cursor := $Cursor as Sprite2D
@onready var _move_sfxr_stream_player := $MoveSfxrStreamPlayer as AudioStreamPlayer
@onready var _buy_sfxr_stream_player := $BuySfxrStreamPlayer as AudioStreamPlayer
@onready var _failed_sfxr_stream_player := $FailedSfxrStreamPlayer as AudioStreamPlayer
@onready var _restart_button := $RestartButton as Sprite2D

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

func _process(_delta: float):
	if Input.is_action_just_pressed("left"):
		_maybe_focus(_currently_focus.neighbor_left)
		_update_cursor()
	if Input.is_action_just_pressed("right"):
		_maybe_focus(_currently_focus.neighbor_right)
		_update_cursor()
	if Input.is_action_just_pressed("up"):
		_maybe_focus(_currently_focus.neighbor_up)
		_update_cursor()
		_cursor.visible = true
		_restart_button.frame = 0
	if Input.is_action_just_pressed("down"):
		_maybe_focus(_currently_focus.neighbor_down)
		_update_cursor()
		_cursor.visible = false
		_restart_button.frame = 1
	if Input.is_action_just_pressed("jump"):
		if _currently_focus.maybe_buy():
			_buy_sfxr_stream_player.play()
		elif is_inside_tree():
			_failed_sfxr_stream_player.play()
