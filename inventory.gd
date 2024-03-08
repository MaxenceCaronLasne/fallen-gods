extends Resource
class_name Inventory

const MAX_LEVEL := 4

var coins := 0
@export var live_level := 1
@export var jump_level := 0

func setup() -> void:
	EventBus.update_coin_score.emit(coins)

func is_able_to_pay(price: int) -> bool:
	return coins - price >= 0

func is_able_to_upgrade_live() -> bool:
	return live_level < MAX_LEVEL

func is_able_to_upgrade_jump() -> bool:
	return jump_level < MAX_LEVEL

func upgrade_live() -> void:
	assert(is_able_to_upgrade_live())
	live_level += 1
	EventBus.update_live_value.emit(live_level)

func upgrade_jump() -> void:
	assert(is_able_to_upgrade_jump())
	jump_level += 1
	EventBus.update_jump_value.emit(jump_level)

func pay(price: int) -> void:
	assert(is_able_to_pay(price))
	coins -= price
	EventBus.update_coin_score.emit(coins)

func maybe_pay(price: int) -> bool:
	if coins - price < 0:
		return false

	coins -= price
	return true

func _init():
	EventBus.coin_picked.connect(_on_coin_picked)

func _on_coin_picked():
	coins += 1
	EventBus.update_coin_score.emit(coins)
