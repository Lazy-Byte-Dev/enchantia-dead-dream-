extends Node
class_name PlayerDirection

@onready var camera: Camera3D = $"../TwistPivot/PitchPivot/SpringArm3D/Camera3D"
@onready var skin: Node3D = $"../YBot/Armature"

@export var input_manager: Node
@export var player: CharacterBody3D

var rotation_speed: float = 12.0
var last_move_dir: Vector3 = Vector3.ZERO
#var input_package: InputPackage
var is_in_water: bool = false

func handle_movement_and_turning(delta: float) -> Vector3:
	var input_package = input_manager.process_input(delta)
	
	if player.check_water():
		return handle_swimming(delta, input_package)
	else:
		return handle_ground_movement_and_turning(delta, input_package)

# Centralized function to handle movement direction and turning
func handle_ground_movement_and_turning(delta: float, input_package: InputPackage) -> Vector3:
	# Get input direction
	var input_dir = input_package.input_direction  # From InputPackage

	# Get the camera's basis and calculate the movement direction
	var camera_basis = camera.global_basis
	var direction = (camera_basis.x * input_dir.x + camera_basis.z * input_dir.y)
	direction.y = 0.0
	direction = direction.normalized()

	# Update the last move direction
	last_move_dir = direction
	
	# Handle the turning logic (rotation)
	if last_move_dir != Vector3.ZERO:
		var target_rotation = atan2(-last_move_dir.x, -last_move_dir.z)  # Z-forward axis
		var current_rotation = skin.rotation.y
		skin.rotation.y = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)

	return last_move_dir
	
	
func handle_swimming(delta: float, input_package: InputPackage):
	# Get input direction
	var input_dir = input_package.input_direction

	# Get the camera's basis and calculate the movement direction
	var camera_basis = camera.global_basis
	var direction = (camera_basis.x * input_dir.x + camera_basis.z * input_dir.y)
	
	#Handle vertical swimming
	if input_package.actions.has("swimup"):
		direction.y += 1
	elif input_package.actions.has("swimdown"):
		direction.y -= 1
		
	direction = direction.normalized()
	last_move_dir = direction
	
	# Handle the turning logic (rotation)
	if last_move_dir != Vector3.ZERO:
		var target_rotation = atan2(-last_move_dir.x, -last_move_dir.z)  # Z-forward axis
		var current_rotation = skin.rotation.y
		skin.rotation.y = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)

	return last_move_dir
