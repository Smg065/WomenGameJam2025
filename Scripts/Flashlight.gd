extends CSGCylinder3D
class_name Flashlight

@export var playerSource : Player
@export var localOffset : Vector3

func _ready() -> void:
	playerSource = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	global_position = playerSource.mainCamera.to_global(localOffset)
	global_basis = playerSource.mainCamera.global_basis
	global_rotate(playerSource.mainCamera.global_basis.x, deg_to_rad(90))
