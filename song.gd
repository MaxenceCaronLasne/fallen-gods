extends Node
class_name Song

@export var _rhythm_audio_stream_player: AudioStreamPlayer
@export var _samples_audio_stream_player: AudioStreamPlayer
@export var _bass_audio_stream_player: AudioStreamPlayer

var _playing: bool = false
var _toned: bool = false

func play() -> void:
	if _playing:
		return

	_playing = true
	_toned = false
	_play()

func stop() -> void:
	_playing = false

	_rhythm_audio_stream_player.stop()
	_samples_audio_stream_player.stop()
	_bass_audio_stream_player.stop()

func tone_down() -> void:
	_toned = true
	_rhythm_audio_stream_player.stop()
	_bass_audio_stream_player.stop()

func _play() -> void:
	if not _toned:
		_rhythm_audio_stream_player.play()
		_bass_audio_stream_player.play()
	_samples_audio_stream_player.play()

func _ready() -> void:
	_samples_audio_stream_player.finished.connect(_on_loop_finished)

func _on_loop_finished() -> void:
	if _playing:
		_play()
