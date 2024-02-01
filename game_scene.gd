extends Node2D

@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _shake_component := %ShakeComponent as ShakeComponent
@onready var _player := $Player as CharacterBody2D

var _is_reseting: bool = false

func _ready():
	_animation_player.play("open_door")

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
