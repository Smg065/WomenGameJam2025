extends RigidBody3D
class_name NPC

@export var cuteVis : Node3D
@export var scaryVis : Node3D
@export var navInfo : NavigationAgent3D
@export var player : Player
@export var visRaycasts : Array[RayCast3D]

@export var speed : float = 1.5
@export var lightBuffer : float = 2

@export var dialogue : Dialogue

@export var isHostile : bool = true
@export var enemySounds : Array[AudioPair]

@export var curWanderPoint : Vector3

@export var allWanderPoints : Array[Node3D]
@export var waitForActive : bool

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if waitForActive:
		return
	if player.talkingTo == self:
		return
	else:
		movement(delta)

func movement(delta):
	#Wander Logic
	if allWanderPoints.size() > 0:
		wander_logic(delta)
	if !isHostile:
		return
	#Chase Logic
	if !can_see_npc():
		chase_logic(delta)

func can_see_npc() -> bool:
	if !player.flashlightOn:
		return false
	
	#If you have line of sight
	var hasVisline : bool = false
	for eachLight in visRaycasts.size():
		if !ray_is_blocked(visRaycasts[eachLight]):
			hasVisline = true
			break
	#No line of sight means free movement
	if !hasVisline:
		return false
	#If you have line of sight, light dot
	var camForward : Vector3 = -player.mainCamera.global_basis.z
	var directLine : Vector3 = player.global_position.direction_to(global_position)
	var inlightPercent : float = camForward.dot(directLine)
	#var lightDistance : float = player.global_position.distance_to(global_position)
	#var ligtDistPercent : float = (player.lightLength - lightDistance + lightBuffer) / player.lightLength
	return inlightPercent > .85

func ray_is_blocked(in_ray : RayCast3D) -> bool:
	in_ray.target_position = in_ray.to_local(player.mainCamera.global_position)
	in_ray.target_position = in_ray.target_position.normalized() * clamp(in_ray.target_position.length(), 0, player.lightLength)
	return in_ray.is_colliding()

func wander_logic(delta: float):
	navInfo.target_position = curWanderPoint
	move_along_path(delta)
	var distance_left = navInfo.target_position.distance_to(global_position)
	if distance_left < 1:
		curWanderPoint = allWanderPoints.pick_random().global_position

func chase_logic(delta: float) -> void:
	navInfo.target_position = player.global_position
	move_along_path(delta)
	var distance_left = navInfo.target_position.distance_to(global_position)
	if distance_left < 1.4:
		game_over()

func move_along_path(delta: float):
	navInfo.get_next_path_position()
	var pathNodes : PackedVector3Array = navInfo.get_current_navigation_path()
	var distToTravel = delta * speed
	#var lookDir : Vector3 = Vector3.FORWARD
	for eachNode in pathNodes.size() - 1:
		var distThisPath : float = pathNodes[eachNode].distance_to(pathNodes[eachNode + 1])
		if distThisPath >= distToTravel:
			var offset : Vector3 = pathNodes[eachNode].direction_to(pathNodes[eachNode + 1]) * distToTravel
			position += offset
			#lookDir = pathNodes[eachNode].direction_to(pathNodes[eachNode + 1])
			break
		distToTravel -= distThisPath

func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")


func noise_timeout() -> void:
	var toUse : AudioPair = enemySounds.pick_random()
	var newSound = MultitrackSound.new()
	newSound.audioPair = toUse
	newSound.max_distance = 10
	add_child(newSound)
