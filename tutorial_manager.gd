extends Node

@export var _saw_spawner: SawSpawner

func _ready():
	assert(_saw_spawner)
	EventBus.saw_destroyed.connect(_on_saw_destroyed)

func _process(delta):
	pass

func _on_player_just_hit():
	_saw_spawner.run(Patterns.get_random_pattern(true))

func _on_saw_destroyed():
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://game_scene.tscn")
