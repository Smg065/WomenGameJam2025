extends TextureRect
class_name GameOver


func _process(_delta: float) -> void:
	modulate = lerp(Color.BLACK, Color.WHITE, time_remaining())
	$FlatSound.volume_db = linear_to_db(SaveData.volume * time_remaining())

func time_remaining() -> float:
	return $Timer.time_left / $Timer.wait_time

func on_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
