extends Node2D

var _MULT_PRELOAD := preload("res://mult_sprite.tscn")

enum State {
	Playing,
	WaitingToClose,
	Closing,
	Choosing,
	Resetting,
	BossDying,
}

@export var _inventory: Inventory
@export var _player_stats: PlayerStats
@export var _boss_stats: BossStats

@onready var _player := $Player as Player
@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _saw_spawner := $SawSpawner as SawSpawner
@onready var _ui := $Ui as Ui
@onready var _background := $Background as Background
@onready var _coin_spawner := $CoinSpawner as CoinSpawner

var _state: State = State.Playing

func shake(intensity: float) -> void:
	EventBus.shake.emit(intensity)

func _enter_playing() -> void:
	print_debug("enter playing")
	_state = State.Playing
	_animation_player.play("open_door")

func _enter_waiting_to_close() -> void:
	print_debug("enter waiting to close")
	_state = State.WaitingToClose
	await get_tree().create_timer(1.0).timeout
	_enter_closing()

func _enter_closing() -> void:
	print_debug("enter closing")
	_state = State.Closing
	_animation_player.play("close_door")
	await _animation_player.animation_finished
	_enter_choosing()

func _enter_choosing() -> void:
	print_debug("enter choosing")
	_ui.enter_choosing_state()
	_state = State.Choosing

func _enter_resetting() -> void:
	print_debug("enter resetting")
	_state = State.Resetting

func _enter_boss_dying() -> void:
	print_debug("enter boss dying")
	_state = State.BossDying
	_stop_saws()
	await get_tree().create_timer(0.2).timeout
	_animation_player.play("boss_die")
	await _animation_player.animation_finished
	await get_tree().create_timer(2.0).timeout
	_animation_player.play("close_door_game_over")

func _gen_mult(mult: int) -> void:
	var m := _MULT_PRELOAD.instantiate() as MultSprite
	m.mult = mult
	m.global_position = _player.global_position
	add_child(m)

func _ready():
	EventBus.saw_destroyed.connect(_on_saw_destroyed)
	EventBus.shake_ended.connect(_on_shake_ended)
	EventBus.go_to_game.connect(_on_go_to_game)
	EventBus.go_to_store.connect(_on_go_to_store)
	_player_stats.died.connect(_on_player_stats_died)
	_boss_stats.updated.connect(_on_boss_updated)
	_boss_stats.died.connect(_on_boss_died)

	_player_stats._init()
	_boss_stats._init()
	_inventory.setup()

	_enter_playing()

func _process(_delta):
	pass

func _generate_coins(destroyed_saws: Array[Saw]) -> void:
	var positions: Array[Vector2] = []
	for s in destroyed_saws:
		positions.append(s.global_position)

	_coin_spawner.generate_coins(positions)

func _destroy_saws() -> int:
	var saws := get_tree().get_nodes_in_group("saws")
	var destroyed_saws: Array[Saw] = []

	for s in saws:
		var saw := s as Saw
		if saw.maybe_destroy():
			destroyed_saws.append(saw)

	_generate_coins(destroyed_saws)

	return len(destroyed_saws)

func _destroy_coins() -> void:
	var coins := get_tree().get_nodes_in_group("coins")
	for c in coins:
		var coin := c as Coin
		coin.queue_free()

func _stop_saws() -> void:
	get_tree().call_group("saws", "queue_free")
	_saw_spawner.stop()

func _on_shake_ended():
	match _state:
		State.Playing: pass
		State.Closing: pass
		State.Resetting:
			get_tree().change_scene_to_file("res://game_scene.tscn")

func _on_saw_destroyed() -> void:
	_background.hit()

func _on_player_finished_dying() -> void:
	_enter_waiting_to_close()

func _on_player_just_hit():
	_player_stats.hit()
	EventBus.shake.emit(2.0)
	_ui.hit_player()

func _on_player_stats_died():
	_player.die()
	_stop_saws()
	_destroy_coins()

func _on_player_just_touched_floor():
	var nb_of_destroyed_saws := _destroy_saws()

	if nb_of_destroyed_saws > 0:
		_boss_stats.hit(nb_of_destroyed_saws)

	if nb_of_destroyed_saws >= 2:
		_gen_mult(nb_of_destroyed_saws)

func _on_boss_updated(value: float) -> void:
	_ui.update_boss_health(value)

func _on_boss_died() -> void:
	_enter_boss_dying()

func _on_go_to_store() -> void:
	get_tree().change_scene_to_file("res://store_scene.tscn")

func _on_go_to_game() -> void:
	get_tree().change_scene_to_file("res://game_scene.tscn")
