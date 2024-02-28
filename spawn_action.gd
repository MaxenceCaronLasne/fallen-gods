extends Resource
class_name SpawnAction

enum SpawnPosition {
	Left,
	Middle,
	Right,
	Random,
}
	
@export var position: SpawnPosition
@export var angle: float ## angle from Vector2.DOWN, pos -> left, neg -> right
@export var then_wait: float ## in seconds
