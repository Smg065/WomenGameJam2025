extends AudioStreamPlayer
class_name FlatSound

func _ready() -> void:
	volume_db = linear_to_db(SaveData.volume)
