extends Node2D

@onready var _player_ui := $PlayerUI as PlayerUI

func _ready():
	_player_ui.init()
