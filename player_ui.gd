extends Node2D
class_name PlayerUI

@onready var _player_ui := $UiPlayerSprite2D as Sprite2D
@onready var _coin_counter := $CoinCounter as Counter

var _inventory := load("res://inventory.tres") as Inventory

func init() -> void:
	for i in range(min(_inventory.live_level + 1, 5)):
		_player_ui.frame = i
		await get_tree().create_timer(0.2).timeout
	_coin_counter.set_value(_inventory.coins)

func hit() -> void:
	_player_ui.frame -= 1

func _ready():
	EventBus.update_coin_score.connect(_coin_counter.set_value)
	EventBus.update_live_value.connect(
		func(value: int): 
			_player_ui.frame = value)
	_coin_counter.set_value(_inventory.coins)

func _process(delta: float):
	pass
