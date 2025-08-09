extends CharacterBody3D
class_name Player

@export var mainCamera : Camera3D
@export var cuteCamera : Camera3D

func _ready() -> void:
	sync_cameras()

func _physics_process(delta: float) -> void:
	var inputVector : Vector2 = get_inputs()
	var fromCamera : Vector3 = Vector3(inputVector.x, 0, inputVector.y)
	velocity = fromCamera * delta * 100
	print(fromCamera * delta * 10)

func get_inputs() -> Vector2:
	var inputVector : Vector2
	inputVector.x = Input.get_axis("MoveBack", "MoveForward")
	inputVector.y = Input.get_axis("MoveLeft", "MoveRight")
	return inputVector.normalized()

func sync_cameras():
	cuteCamera.position = mainCamera.position
	cuteCamera.rotation = mainCamera.rotation
