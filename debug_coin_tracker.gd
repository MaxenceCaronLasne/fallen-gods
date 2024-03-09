extends Node

@onready var _timer := $Timer as Timer

var _inventory := load("res://inventory.tres") as Inventory
var _debug_tracker_res := load("res://debug_tracker.tres") as DebugTracker

func _ready():
	_debug_tracker_res.coin_values.clear()
	_timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	pass

func _exit_tree():
	ResourceSaver.save(_debug_tracker_res, "res://debug_tracker.tres")

func _on_timer_timeout() -> void:
	_debug_tracker_res.coin_values.append(_inventory.coins)
