extends Resource
class_name Inventory

var _coins := 0

func _init():
	EventBus.coin_picked.connect(_on_coin_picked)

func _on_coin_picked():
	_coins += 1
	print_debug(_coins)
