extends Node2D
class_name Counter

@onready var _numbers: Array[Sprite2D] = [
	$NumberSprite2D_0 as Sprite2D,
	$NumberSprite2D_1 as Sprite2D,
	$NumberSprite2D_2 as Sprite2D,
	$NumberSprite2D_3 as Sprite2D,
	$NumberSprite2D_4 as Sprite2D,
]

var _value := 0

func set_value(new_value) -> void:
	if new_value >= 99999:
		push_warning("Counter overflow, clamping...")

	_value = clampi(new_value, 0, 99999)
	_update()

func increment() -> void:
	set_value(_value + 1)

func _update() -> void:
	for i in range(len(_numbers)):
		var order := pow(10, i)
		@warning_ignore("integer_division")
		_numbers[i].frame = int(_value / order) % 10

func _ready():
	_update()

func _process(_delta):
	pass
