extends RigidBody3D
class_name NPC

@export var cuteVis : Sprite3D
@export var scaryVis : MeshInstance3D
@export var navInfo : NavigationAgent3D
@export var player : Player
@export var visRaycasts : Array[RayCast3D]

@export var speed : float = 1.5
@export var lightBuffer : float = 2

func _physics_process(delta: float) -> void:
	if !can_see_npc():
		chase_logic(delta)

func can_see_npc() -> bool:
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
	var lightDistance : float = player.global_position.distance_to(global_position)
	var ligtDistPercent : float = (player.lightLength - lightDistance + lightBuffer) / player.lightLength
	return inlightPercent * ligtDistPercent > .2

func ray_is_blocked(in_ray : RayCast3D) -> bool:
	in_ray.target_position = in_ray.to_local(player.mainCamera.global_position)
	in_ray.target_position = in_ray.target_position.normalized() * clamp(in_ray.target_position.length(), 0, player.lightLength)
	return in_ray.is_colliding()

func chase_logic(delta: float) -> void:
	navInfo.target_position = player.global_position
	navInfo.get_next_path_position()
	var pathNodes : PackedVector3Array = navInfo.get_current_navigation_path()
	var distToTravel = delta * speed
	for eachNode in pathNodes.size() - 1:
		var distThisPath : float = pathNodes[eachNode].distance_to(pathNodes[eachNode + 1])
		if distThisPath >= distToTravel:
			var offset : Vector3 = pathNodes[eachNode].direction_to(pathNodes[eachNode + 1]) * distToTravel
			position += offset
			break
		distToTravel -= distThisPath
