extends Resource
class_name BossStats

signal died

@export var _damage_per_hit: float = 1.0

var _health: float = 100.0

func hit(nb: int) -> void:
	_health -= nb * _damage_per_hit
	
	print_debug("boss health=", _health)
	
	if _health < 0:
		died.emit()

func _init():
	_health = 100.0
