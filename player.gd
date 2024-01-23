extends CharacterBody2D

signal just_touched_floor
signal just_died

@onready var _hitbox := $HitBox as Area2D
@onready var _on_floor_notifier := $OnFloorNotifier as OnFloorNotifier

func _ready() -> void:
	_hitbox.body_entered.connect(_on_hit_box_body_entered)
	_on_floor_notifier.just_touched_floor.connect(
		_on_floor_notifier_just_touched_floor)

func _physics_process(_delta: float):
	move_and_slide()

func _on_hit_box_body_entered(_body):
	just_died.emit()
	queue_free()

func _on_floor_notifier_just_touched_floor():
	get_tree().call_group("saws", "maybe_destroy")
	just_touched_floor.emit()
