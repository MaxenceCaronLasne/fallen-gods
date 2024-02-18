extends Node2D

enum State {
	Playing,
	WaitingToClose,
	Closing,
	Resetting,
}

@export var _player_stats: PlayerStats
@export var _boss_stats: BossStats

@onready var _player := $Player as Player
@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _background_sprite := $BackgroundSprite as AnimatedSprite2D
@onready var _saw_spawner := $SawSpawner as SawSpawner
@onready var _ui := $Ui as Ui

var _state: State = State.Playing

func _ready():
	_animation_player.play("open_door")
	EventBus.saw_destroyed.connect(_on_saw_destroyed)
	_player_stats.died.connect(_on_player_stats_died)
	_boss_stats.updated.connect(_on_boss_updated)
	_player_stats._init()
	_boss_stats._init()

func _process(_delta):
	pass

func _destroy_saws() -> void:
	var saws := get_tree().get_nodes_in_group("saws")
	var nb_of_destroyed_saws := 0
	
	for s in saws:
		var saw := s as Saw
		var is_destroyed := saw.maybe_destroy()
		if is_destroyed:
			nb_of_destroyed_saws += 1

	if nb_of_destroyed_saws > 0:
		_boss_stats.hit(nb_of_destroyed_saws)

func _stop_saws() -> void:
	get_tree().call_group("saws", "queue_free")
	_saw_spawner.stop()

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

func _on_player_just_hit():
	_player_stats.hit()
	_ui.hit_player()

func _on_player_stats_died():
	_player.die()
	_stop_saws()

func _on_player_just_touched_floor():
	_destroy_saws()

func _on_boss_updated(value: float) -> void:
	_ui.update_boss_health(value)
