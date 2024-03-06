extends Control

@export var _currently_focus: StoreShelf

func _ready():
	pass

func _maybe_focus(neighbor_path: NodePath) -> bool:
	if neighbor_path.is_empty():
		return false

	var neighbor := _currently_focus.get_node(neighbor_path) as StoreShelf
	_currently_focus = neighbor if neighbor != null else _currently_focus

	return true

func _process(delta: float):
	if Input.is_action_just_pressed("left"):
		_maybe_focus(_currently_focus.focus_neighbor_left)
	if Input.is_action_just_pressed("right"):
		_maybe_focus(_currently_focus.focus_neighbor_right)
	if Input.is_action_just_pressed("jump"):
		var res := _currently_focus.maybe_buy()
		print_debug("tried to buy: ", res)
