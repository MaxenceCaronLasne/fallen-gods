extends Resource
class_name SpawnPattern

static var _patterns: Array[SpawnPattern] = [
	load("res://patterns/one_bullet_left.tres") as SpawnPattern,
	load("res://patterns/one_bullet_right.tres") as SpawnPattern,
	load("res://patterns/two_bullet_left.tres") as SpawnPattern,
	load("res://patterns/two_bullet_right.tres") as SpawnPattern,
	load("res://patterns/fork.tres") as SpawnPattern,
	load("res://patterns/three_bullets_left.tres") as SpawnPattern,
	load("res://patterns/three_bullets_right.tres") as SpawnPattern,
]

static func get_random_pattern() -> SpawnPattern:
	return _patterns[randi_range(0, len(_patterns) - 1)]

@export_range(1, 10) var difficulty: int = 1
@export var actions: Array[SpawnAction] = []
