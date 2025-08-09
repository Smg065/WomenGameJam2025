extends RigidBody3D
class_name NPC

@export var cuteVis : Sprite3D
@export var scaryVis : MeshInstance3D
@export var navInfo : NavigationAgent3D
@export var player : Player

@export var speed : float = 1.5

func _physics_process(delta: float) -> void:
	
	chase_logic(delta)

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
