extends Control
class_name StoreShelf

@export var _inventory: Inventory
@export var _price: int

func maybe_buy() -> bool:
	return _inventory.maybe_pay(_price)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
