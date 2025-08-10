extends CharacterBody3D
class_name Player

@export_category("Explore")
@export var mainCamera : Camera3D
@export var cuteCamera : Camera3D
@export var mouseSensitivity : float = .005

@export var cuteLightVis : Array[NodePath]
var cuteCSG : CSGCombiner3D

@export var lightLength : float = 9
@export var flashlightOn : bool
@export var charge : float = 60
@export var chargeBar : TextureProgressBar
@export var interactCast : RayCast3D

@export_category("VN")
@export var talkingTo : NPC
@export var talkingUi : TalkingUi

@export_category("Misc")
@export var wanderUI : Control
@export var convoUI : Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for eachNode in get_tree().get_nodes_in_group("Flashlight"):
		cuteLightVis.append(eachNode.get_path())
	cuteCSG = get_tree().get_first_node_in_group("CuteCSG")
	flashlightOn = true
	toggle_flashlight()

func _process(delta: float) -> void:
	if talkingTo == null:
		controls_main(delta)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		controls_conversation()

func controls_main(delta):
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
	sync_cams()
	lose_charge(delta)
	if Input.is_action_just_pressed("ToggleFlashlight"):
		toggle_flashlight()
	cast_interact()

func controls_conversation():
	if Input.is_action_just_pressed("Interact"):
		var toLine : int = talkingUi.push_nextline()
		#Stop talking
		if toLine == -2:
			talkingTo = null
			set_talking_UI()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			return
		if toLine == -1:
			return
		talkingUi.switch_line(talkingTo.dialogue.allLines[toLine])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
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

func sync_cams():
	cuteCamera.global_position = mainCamera.global_position
	cuteCamera.global_rotation = mainCamera.global_rotation

func toggle_flashlight():
	if charge <= 0 && !flashlightOn:
		return
	flashlightOn = !flashlightOn
	for eachItem in cuteLightVis:
		get_node(eachItem).visible = flashlightOn
	cuteCSG.use_collision = flashlightOn

func lose_charge(delta : float):
	if !flashlightOn:
		return
	charge -= delta
	chargeBar.value = charge
	if charge <= 0:
		toggle_flashlight()

func cast_interact():
	#Initial Pass
	if !Input.is_action_just_pressed("Interact"):
		return
	if !interactCast.is_colliding():
		return
	#What are you interacting with?
	var col : CollisionObject3D = interactCast.get_collider()
	#Characters
	if col.get_collision_layer_value(2):
		var canTalk = true
		#Is it hostile?
		if col.isHostile:
			if !col.can_see_npc():
				canTalk = false
		if canTalk:
			talkingTo = interactCast.get_collider()
			talkingUi.switch_line(talkingTo.dialogue.allLines[0])
			set_talking_UI()
		#Characters
	if col.get_collision_layer_value(3):
		print("Interactable")

func set_talking_UI():
	wanderUI.visible = talkingTo == null
	convoUI.visible = talkingTo != null
