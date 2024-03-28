extends Node

@export var _songs: Array[Song] = []
var _current_song_index := 0

var _is_mute = false

func play() -> void:
	_songs[_current_song_index].stop()
	_current_song_index = (_current_song_index + 1) % len(_songs)
	_songs[_current_song_index].play()

func tone_down() -> void:
	_songs[_current_song_index].tone_down()

func stop() -> void:
	_songs[_current_song_index].stop()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(2, not _is_mute)
		_is_mute = not _is_mute
