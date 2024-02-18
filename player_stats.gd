extends Resource
class_name PlayerStats

signal died

@export var _max_health: int = 4

var _health: int = 0

func hit() -> void:
	_health -= 1
	if _health < 1:
		died.emit()

func _init():
	_health = _max_health
