extends Node2D
class_name Counter

@onready var _numbers: Array[Sprite2D]= [
	$NumberSprite2D_0 as Sprite2D,
	$NumberSprite2D_1 as Sprite2D,
	$NumberSprite2D_2 as Sprite2D,
	$NumberSprite2D_3 as Sprite2D,
	$NumberSprite2D_4 as Sprite2D,
]

var _value := 0

func set_value(new_value) -> void:
	_value = new_value
	_update()

func increment() -> void:
	set_value(_value + 1)

func _update() -> void:
	for i in range(len(_numbers)):
		var order := 10 ** i
		#_numbers[i].visible = _value >= order
		_numbers[i].frame = (_value / order) % 10

func _ready():
	_update()

func _process(_delta):
	pass
