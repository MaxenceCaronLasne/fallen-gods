extends Resource
class_name Inventory

var _coins := 0

func setup() -> void:
	EventBus.update_coin_score.emit(_coins)

func maybe_pay(price: int) -> bool:
	if _coins - price < 0:
		return false
	
	_coins -= price
	return true

func _init():
	EventBus.coin_picked.connect(_on_coin_picked)


func _on_coin_picked():
	_coins += 1
	EventBus.update_coin_score.emit(_coins)
