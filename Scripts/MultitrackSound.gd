extends AudioStreamPlayer3D
class_name MultitrackSound

@export var audioPair : AudioPair
@export var persist : bool
var multiStream : AudioStreamSynchronized
@export var player : Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	multiStream = AudioStreamSynchronized.new()
	multiStream.stream_count = 2
	multiStream.set_sync_stream(0, audioPair.cuteSound)
	multiStream.set_sync_stream(1, audioPair.horrorSound)
	stream = multiStream
	volume_db = linear_to_db(SaveData.volume)
	if !persist:
		finished.connect(queue_free)

func _process(_delta: float) -> void:
	if !player.flashlightOn:
		set_stream_ratios(0)
		return
	var lookingAngle : float = get_looking_angle()
	set_stream_ratios(clamp(lookingAngle, 0, 1))

func get_looking_angle() -> float:
	return player.mainCamera.global_basis.z.dot(player.mainCamera.global_position.direction_to(global_position))

func set_stream_ratios(setRatio : float):
	var cuteVolume : float = setRatio
	var horrorVolume : float = 1 - setRatio
	multiStream.set_sync_stream_volume(0, linear_to_db(cuteVolume))
	multiStream.set_sync_stream_volume(1, linear_to_db(horrorVolume))
