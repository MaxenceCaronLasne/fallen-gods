extends Node2D

func _ready():
	pass

func _process(_delta):
	pass

func _on_player_just_died():
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://game_scene.tscn")
