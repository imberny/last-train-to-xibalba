class_name AudioStreamPlayer2DPool extends Node2D

@export var audio_stream: AudioStream
@export var pool_size := 1
@export_range(-80.0, 24.0) var volume_db := 0.0

var _stream_players: Array[AudioStreamPlayer2D]
var _index := 0


func _ready() -> void:
	for _i in pool_size:
		var stream_player := AudioStreamPlayer2D.new()
		stream_player.stream = audio_stream
		stream_player.volume_db = volume_db
		_stream_players.push_back(stream_player)
		add_child(stream_player)


func play() -> void:
	var stream_player := _stream_players[_index]
	stream_player.play()
	_index = wrapi(_index + 1, 0, len(_stream_players))
