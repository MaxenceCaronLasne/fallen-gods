extends Node2D
class_name Ui

@onready var _player_ui := $UiPlayerSprite2D as Sprite2D
@onready var _first_jauge := $FirstTextureProgressBar as TextureProgressBar
@onready var _second_jauge := $SecondTextureProgressBar as TextureProgressBar
@onready var _third_jauge := $ThirdTextureProgressBar as TextureProgressBar
@onready var _coin_counter := $CoinCounter as Counter

func hit_player() -> void:
	_player_ui.frame -= 1

func update_boss_health(value: float) -> void:
	_first_jauge.value = value
	_second_jauge.value = value
	_third_jauge.value = value

func _init_player_jauge() -> void:
	for i in range(5):
		_player_ui.frame = i
		await get_tree().create_timer(0.2).timeout

func _init_boss_jauge() -> void:
	for i in range(101):
		update_boss_health(i)
		await get_tree().create_timer(0.005).timeout

func _ready():
	_init_player_jauge()
	_init_boss_jauge()
	EventBus.update_coin_score.connect(_coin_counter.set_value)

func _process(_delta):
	pass
