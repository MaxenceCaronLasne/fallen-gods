extends Node2D

@onready var _counter := $Counter as Counter

func _ready():
	_counter.set_value(0)

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		_counter.increment()
	_counter.increment()