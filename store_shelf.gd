extends Sprite2D
class_name StoreShelf

enum Kind {
	Life,
	Jump,
	Restart
}

@export var _inventory: Inventory
@export var _price: int
@export var _kind: Kind
@export var neighbor_left: StoreShelf
@export var neighbor_right: StoreShelf
@export var neighbor_up: StoreShelf
@export var neighbor_down: StoreShelf

func maybe_buy() -> bool:
	if _kind == Kind.Restart:
		_restart()
		return false

	if not _inventory.is_able_to_pay(_price):
		return false

	match _kind:
		Kind.Life: return _maybe_buy_life()
		Kind.Jump: return _maybe_buy_jump()
		_:
			assert(false, "invalid kind")
			return false

func _restart() -> void:
	get_tree().change_scene_to_file("res://game_scene.tscn")

func _maybe_buy_life() -> bool:
	if not _inventory.is_able_to_upgrade_live():
		return false

	_inventory.pay(_price)
	_inventory.upgrade_live()
	frame += 1

	return true

func _maybe_buy_jump() -> bool:
	if not _inventory.is_able_to_upgrade_jump():
		return false

	_inventory.pay(_price)
	_inventory.upgrade_jump()
	frame += 1

	return true
