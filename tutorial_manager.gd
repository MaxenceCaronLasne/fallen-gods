extends Node

@export var _saw_spawner: SawSpawner
@export var _background: Node2D

func _ready():
	assert(_saw_spawner)
	EventBus.saw_destroyed.connect(_on_saw_destroyed)

func _on_player_just_hit():
	_saw_spawner.run(Patterns.get_random_pattern(true))

func _on_saw_destroyed():
	var tween := get_tree().create_tween()

	tween\
		.tween_property(_background, "modulate:a", 1.0, 2.0)\
		.set_delay(2.0)\
		.from(0.0)\
		.set_trans(Tween.TRANS_LINEAR)

	await tween.finished
	get_tree().change_scene_to_file.call_deferred("res://game_scene.tscn")
