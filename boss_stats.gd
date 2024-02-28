extends Resource
class_name BossStats

signal updated(value: float)
signal died

@export var _damage_per_hit: float = 1.0

var _health: float = 100.0

func hit(nb: int) -> void:
	var tmp := _health
	_health -= nb * _damage_per_hit

	updated.emit(_health)

	if _health < 66 and 66 < tmp or _health < 33 and 33 < tmp:
		EventBus.boss_hp_tier_annihilated
	if _health < 0:
		died.emit()

func _init():
	_health = 100.0
