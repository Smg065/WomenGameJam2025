extends CharacterBody3D
class_name Player

@export var mainCamera : Camera3D
@export var cuteCamera : Camera3D
@export var mouseSensitivity : float = .005

func _ready() -> void:
	sync_cameras()

func _process(delta: float) -> void:
	var inputVector : Vector2 = get_move_vector()
	var relativeMove : Vector3 = global_transform.basis.z * inputVector.y
	relativeMove += global_transform.basis.x * inputVector.x
	velocity = relativeMove * delta * 150
	move_and_slide()
	if Input.is_action_just_pressed("Pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	move_camera(-Input.get_vector("CameraLeft","CameraRight","CameraUp","CameraDown") * Vector2(10,7))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		clamp(mainCamera.rotation_degrees.x, -120, 120)
		move_camera(-event.relative)

func get_move_vector() -> Vector2:
	var inputVector : Vector2
	inputVector.y = Input.get_axis("MoveForward", "MoveBack")
	inputVector.x = Input.get_axis("MoveLeft", "MoveRight")
	return inputVector.normalized()

func move_camera(cameraInput : Vector2) -> void:
	rotate_y(cameraInput.x * mouseSensitivity)
	mainCamera.rotate_x(cameraInput.y * mouseSensitivity)

func sync_cameras():
	cuteCamera.position = mainCamera.position
	cuteCamera.rotation = mainCamera.rotation
