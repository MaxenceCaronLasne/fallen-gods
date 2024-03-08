extends Node2D

@export var _speed: float = 100.0

@onready var _sprites: Array[Sprite2D] = [
	$Sprite1 as Sprite2D, $Sprite2 as Sprite2D
]

func _ready():
	pass

func _process(delta: float):
	for s in _sprites:
		s.position.x -= _speed * delta
	if _sprites[1].position.x < 0:
		_sprites[0].position.x = 0
		_sprites[1].position.x = _sprites[0].get_rect().size.x
