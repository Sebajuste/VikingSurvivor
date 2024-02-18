extends Node

signal loop_finished
signal music_changed(audio_stream : AudioStream)

var _next_music : AudioStream = null


var _audio_stream_player := AudioStreamPlayer.new()
var _last_position := 0.0


func _ready():
	_audio_stream_player.autoplay = true
	_audio_stream_player.bus = "Music"
	add_child(_audio_stream_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var position := _audio_stream_player.get_playback_position()
	if position < _last_position and _last_position != 0.0:
		loop_finished.emit()
		if _next_music:
			_audio_stream_player.stream = _next_music
			_audio_stream_player.play()
			music_changed.emit(_next_music)
			_next_music = null
	_last_position = position

func play_next(audio : AudioStream):
	
	if not _audio_stream_player.playing:
		change(audio)
	else:
		_next_music = audio
	pass

func change(audio : AudioStream):
	_next_music = null
	_audio_stream_player.stop()
	_audio_stream_player.stream = audio
	_audio_stream_player.play()
