extends Resource
class_name BossStats

signal died

var _health: float = 100.0

func hit(damages: float) -> void:
	_health -= damages
	
	if _health < 0:
		died.emit()

func _init():
	_health = 100.0
