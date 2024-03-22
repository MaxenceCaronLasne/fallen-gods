extends Sprite2D
class_name StoreShelf

enum Kind {
	Life,
	Jump,
	Restart
}

@export var _inventory: Inventory
@export var _prices: Array[int] = [0, 0, 0, 0]
@export var _kind: Kind
@export var neighbor_left: StoreShelf
@export var neighbor_right: StoreShelf
@export var neighbor_up: StoreShelf
@export var neighbor_down: StoreShelf

func maybe_buy() -> bool:
	if _kind == Kind.Restart:
		_restart()
		return false

	match _kind:
		Kind.Life:
			if _inventory.is_able_to_pay(_prices[_inventory.live_level]):
				return _maybe_buy_life()
		Kind.Jump: 
			if _inventory.is_able_to_pay(_prices[_inventory.jump_level]):
				return _maybe_buy_jump()
		_:
			assert(false, "invalid kind")
			return false

	return false

func _restart() -> void:
	get_tree().change_scene_to_file("res://game_scene.tscn")

func _maybe_buy_life() -> bool:
	if not _inventory.is_able_to_upgrade_live():
		return false

	_inventory.pay(_prices[_inventory.live_level])
	_inventory.upgrade_live()
	frame += 1

	return true

func _maybe_buy_jump() -> bool:
	if not _inventory.is_able_to_upgrade_jump():
		return false

	_inventory.pay(_prices[_inventory.jump_level])
	_inventory.upgrade_jump()
	frame += 1

	return true

func _ready():
	match _kind:
		Kind.Life:
			frame = _inventory.live_level
		Kind.Jump:
			frame = _inventory.jump_level
