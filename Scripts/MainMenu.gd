extends Control
class_name MainMenu

@export var allCatagories : Array[TextureRect]

func swap_catagory(newCatagory : int):
	for eachCatagory in allCatagories.size():
		allCatagories[eachCatagory].visible = eachCatagory == newCatagory

func on_fullscreen_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func on_yes_exit_pressed() -> void:
	get_tree().quit()

func on_mouse_slider_value_changed(value: float) -> void:
	SaveData.mouseSensitivity = value

func on_volume_slider_value_changed(value: float) -> void:
	SaveData.volume = value
	$AudioStreamPlayer.volume_db = linear_to_db(value)
