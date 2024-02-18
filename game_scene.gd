extends Node2D

enum State {
	Playing,
	WaitingToClose,
	Closing,
	Resetting,
}

@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _background_sprite := $BackgroundSprite as AnimatedSprite2D
@onready var _saw_spawner := $SawSpawner as SawSpawner

var _state: State = State.Playing

func _ready():
	_animation_player.play("open_door")
	EventBus.saw_destroyed.connect(_on_saw_destroyed)

func _process(_delta):
	pass

func _stop_saws() -> void:
	get_tree().call_group("saws", "queue_free")
	_saw_spawner.stop()

func _on_player_just_died():
	_stop_saws()

func _on_shake_component_ended_shaking():
	match _state:
		State.Playing: pass
		State.Closing: pass
		State.Resetting:
			get_tree().change_scene_to_file("res://game_scene.tscn")

func _on_saw_destroyed() -> void:
	_background_sprite.play("hit")
	await _background_sprite.animation_finished
	if _state == State.Playing:
		_background_sprite.play("default")

func _on_player_finished_dying() -> void:
	_state = State.WaitingToClose
	await get_tree().create_timer(1.0).timeout
	_state = State.Closing
	_animation_player.play("close_door")
	await _animation_player.animation_finished
	_state = State.Resetting
