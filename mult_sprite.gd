extends Sprite2D
class_name MultSprite

var mult: int = 2 :
	set(value):
		assert(2 <= mult and mult <= 19)
		frame = value - 2
		mult = value

func _ready():
	pass

func _process(_delta):
	pass
