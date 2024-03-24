extends Node2D
class_name Ui

enum State {
	Idle,
	Choosing,
}

enum ChoosingMenu {
	Restart,
	GoToStore,
}

@onready var _first_jauge := $FirstTextureProgressBar as TextureProgressBar
@onready var _second_jauge := $SecondTextureProgressBar as TextureProgressBar
@onready var _third_jauge := $ThirdTextureProgressBar as TextureProgressBar
@onready var _restart_label := $RestartLabel as Sprite2D
@onready var _go_to_store_label := $StoreLabel as Sprite2D
@onready var _cursor := $Cursor as Sprite2D
@onready var _bip_sfxr_stream_player := $BipSfxrStreamPlayer as AudioStreamPlayer
@onready var _real_player_ui := $PlayerUI as PlayerUI

var _state := State.Idle
var _menu_state := ChoosingMenu.Restart

func enter_choosing_state() -> void:
	_state = State.Choosing
	_show_game_over_menu()

func _hide_game_over_menu() -> void:
	_restart_label.visible = false
	_go_to_store_label.visible = false
	_cursor.visible = false

func _show_game_over_menu() -> void:
	_restart_label.visible = true
	_go_to_store_label.visible = true
	_cursor.visible = true

func hit_player() -> void:
	_real_player_ui.hit()

func update_boss_health(value: float) -> void:
	_first_jauge.value = value
	_second_jauge.value = value
	_third_jauge.value = value

func _init_player_jauge() -> void:
	_real_player_ui.init()

func _init_boss_jauge() -> void:
	for i in range(101):
		update_boss_health(i)
		await get_tree().create_timer(0.005).timeout

func _ready():
	_init_player_jauge()
	_init_boss_jauge()
	_hide_game_over_menu()

func _process_choosing(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		_menu_state = ChoosingMenu.Restart
		_cursor.position = _restart_label.position
		_bip_sfxr_stream_player.play()
	if Input.is_action_just_pressed("down"):
		_menu_state = ChoosingMenu.GoToStore
		_cursor.position = _go_to_store_label.position
		_bip_sfxr_stream_player.play()
	if Input.is_action_just_pressed("jump"):
		_bip_sfxr_stream_player.play()
		match _menu_state:
			ChoosingMenu.Restart: EventBus.go_to_game.emit()
			ChoosingMenu.GoToStore: EventBus.go_to_store.emit()

func _process(delta: float):
	match _state:
		State.Idle: return
		State.Choosing: _process_choosing(delta)
