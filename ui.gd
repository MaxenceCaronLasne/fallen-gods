extends Node2D
class_name Ui

@onready var _player_ui := $UiPlayerSprite2D as Sprite2D

func hit_player() -> void:
	_player_ui.frame -= 1

func _ready():
	for i in range(5):
		_player_ui.frame = i
		await get_tree().create_timer(0.2).timeout

func _process(_delta):
	pass
