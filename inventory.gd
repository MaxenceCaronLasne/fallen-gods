extends Resource
class_name Inventory

const MAX_LEVEL := 4

var _coins := 0
var _live_level := 1
var _jump_level := 1

func setup() -> void:
	EventBus.update_coin_score.emit(_coins)

func is_able_to_pay(price: int) -> bool:
	print_debug("price: ", price, "; coins: ", _coins)
	return _coins - price >= 0

func is_able_to_upgrade_live() -> bool:
	return _live_level < MAX_LEVEL

func is_able_to_upgrade_jump() -> bool:
	return _jump_level < MAX_LEVEL

func upgrade_live() -> void:
	assert(is_able_to_upgrade_live())
	_jump_level += 1

func upgrade_jump() -> void:
	assert(is_able_to_upgrade_jump())
	_jump_level += 1

func pay(price: int) -> void:
	assert(is_able_to_pay(price))
	_coins -= price

func maybe_pay(price: int) -> bool:
	print_debug("price: ", price, "; coins: ", _coins)
	if _coins - price < 0:
		return false

	_coins -= price
	return true

func _init():
	EventBus.coin_picked.connect(_on_coin_picked)

func _on_coin_picked():
	_coins += 1
	EventBus.update_coin_score.emit(_coins)
