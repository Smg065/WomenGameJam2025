extends CSGCylinder3D
class_name Flashlight

@export var playerSource : Player
@export var localOffset : Vector3

func _process(delta: float) -> void:
	global_position = playerSource.mainCamera.to_global(localOffset)
	global_basis = playerSource.mainCamera.global_basis
	global_rotate(playerSource.mainCamera.global_basis.x, deg_to_rad(90))
