extends Control
class_name StoreShelf

enum Kind {
	Life,
	Jump,
}

@export var _inventory: Inventory
@export var _price: int
@export var _kind: Kind

func maybe_buy() -> bool:
	if not _inventory.is_able_to_pay(_price):
		return false

	match _kind:
		Kind.Life: return _maybe_buy_life()
		Kind.Jump: return _maybe_buy_jump()
		_: 
			assert(false, "invalid kind")
			return false

func _maybe_buy_life() -> bool:
	if not _inventory.is_able_to_upgrade_live():
		return false

	_inventory.pay(_price)
	_inventory.upgrade_live()
	
	return true

func _maybe_buy_jump() -> bool:
	if not _inventory.is_able_to_upgrade_jump():
		return false
	
	_inventory.pay(_price)
	_inventory.upgrade_jump()
	
	return true
