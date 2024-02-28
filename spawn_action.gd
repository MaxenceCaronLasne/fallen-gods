extends Resource
class_name SpawnAction

enum SpawnPosition {
	Left,
	Middle,
	Right,
	Random,
}
	
@export var position: SpawnPosition
@export_range(-90, 90) var angle: float ## negative
@export var then_wait: float ## in seconds
