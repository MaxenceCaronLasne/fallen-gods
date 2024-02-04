extends Node2D

@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _background_sprite := $BackgroundSprite as AnimatedSprite2D

var _is_reseting: bool = false

func _ready():
	_animation_player.play("open_door")
	EventBus.saw_destroyed.connect(_on_saw_destroyed)

func _process(_delta):
	pass

func _on_player_just_died():
	_animation_player.play("close_door")

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "close_door":
		_is_reseting = true

func _on_shake_component_ended_shaking():
	if _is_reseting:
		get_tree().change_scene_to_file("res://game_scene.tscn")

func _on_saw_destroyed() -> void:
	_background_sprite.play("hit")
	await _background_sprite.animation_finished
	_background_sprite.play("default")
