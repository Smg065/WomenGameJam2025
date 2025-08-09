extends RigidBody3D
class_name NPC

@export var cuteVis : Sprite3D
@export var scaryVis : MeshInstance3D
@export var navInfo : NavigationAgent3D
@export var player : Player

func _process(delta: float) -> void:
	navInfo.target_position = player.global_position
	var pathNodes : PackedVector3Array = navInfo.get_current_navigation_path()
	#for eachNode in pathNodes.size():
	#	eachNode
	linear_velocity = navInfo.get_velocity()
