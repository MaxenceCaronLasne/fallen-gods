extends Resource
class_name SpawnPattern

static var _patterns: Array[SpawnPattern] = [
	load("res://patterns/one_bullet.tres") as SpawnPattern,
]

static func get_random_pattern() -> SpawnPattern:
	return _patterns[randi_range(0, len(_patterns) - 1)]

@export var actions: Array[SpawnAction] = []
