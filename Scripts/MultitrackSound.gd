extends AudioStreamPlayer3D
class_name MultitrackSound

@export var audioPair : AudioPair
var multiStream : AudioStreamSynchronized

func _ready() -> void:
	multiStream = AudioStreamSynchronized.new()
	multiStream.stream_count = 2
	multiStream.set_sync_stream(0, audioPair.cuteSound)
	multiStream.set_sync_stream(1, audioPair.horrorSound)
	stream = multiStream

func set_stream_ratios(setRatio : float):
	linear_to_db()
	multiStream.set_sync_stream_volume(0, 1)
	multiStream.set_sync_stream_volume(1, 1)
