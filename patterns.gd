extends Node

enum State {
	Pause,
	LowRisk,
	HighRisk,
	LowRecovery,
	HighRecovery,
}

var _state := State.Pause
var _risk := 0.75

var _pause_patterns: Array[SpawnPattern] = [
	load("res://patterns/one_bullet_left.tres") as SpawnPattern,
	load("res://patterns/one_bullet_right.tres") as SpawnPattern,
]

var _low_risk_patterns: Array[SpawnPattern] = [
	load("res://patterns/two_bullet_left.tres") as SpawnPattern,
	load("res://patterns/two_bullet_right.tres") as SpawnPattern,
]

var _high_risk_patterns: Array[SpawnPattern] = [
	load("res://patterns/fork.tres") as SpawnPattern,
	load("res://patterns/three_bullets_left.tres") as SpawnPattern,
	load("res://patterns/three_bullets_right.tres") as SpawnPattern,
]

func get_random_pattern() -> SpawnPattern:
	_next()
	match _state:
		State.Pause, State.LowRecovery, State.HighRecovery:
			return _pause_patterns[randi_range(0, len(_pause_patterns) - 1)]
		State.LowRisk:
			return _low_risk_patterns[randi_range(0, len(_low_risk_patterns) - 1)]
		State.HighRisk:
			return _high_risk_patterns[randi_range(0, len(_high_risk_patterns) - 1)]
		_:
			assert(false)
			return null

func _next() -> void:
	match _state:
		State.Pause: _state = State.LowRisk if randf() < _risk else State.HighRisk
		State.LowRisk: _state = State.LowRecovery
		State.HighRisk: _state = State.HighRecovery
		State.LowRecovery: _state = State.Pause
		State.HighRecovery: _state = State.LowRecovery

func _ready():
	EventBus.boss_hp_tier_annihilated.connect(_on_boss_hp_tier_annihilated)

func _process(_delta):
	pass

func _on_boss_hp_tier_annihilated() -> void:
	_risk -= 0.25
