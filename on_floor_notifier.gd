extends Node
class_name OnFloorNotifier

signal just_touched_floor

@export var _actor: CharacterBody2D

var _touched_floor_last_frame: bool = false

func _ready():
	assert(_actor)

func _physics_process(_delta):
	if _actor.is_on_floor() and not _touched_floor_last_frame:
		just_touched_floor.emit()
	
	_touched_floor_last_frame = _actor.is_on_floor()
