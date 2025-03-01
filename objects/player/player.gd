extends RigidBody2D

enum PlayerType {PLAYER_1, PLAYER_2}
enum CharacterType {OFFENSE, DEFENSE}

@export var rotation_speed: float = 3.0  # Rotation speed in radians per second
@export var thrust: float = 300.0        # Force applied when moving forward/backward
@export var player_type: PlayerType = PlayerType.PLAYER_1
@export var character_type: CharacterType = CharacterType.OFFENSE

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var turn_direction = 0
	var move_direction = 0
	
	if player_type == PlayerType.PLAYER_1:
		if Input.is_action_pressed("p1_rot_clockwise"):  # D key
			turn_direction += 1
		if Input.is_action_pressed("p1_rot_counterclockwise"):   # A key
			turn_direction -= 1
		if Input.is_action_pressed("p1_move_forward"):  # W key
			move_direction += 1
		if Input.is_action_pressed("p1_move_backward"): # S key
			move_direction -= 1
	else:
		if Input.is_action_pressed("p2_rot_clockwise"):  # D key
			turn_direction += 1
		if Input.is_action_pressed("p2_rot_counterclockwise"):   # A key
			turn_direction -= 1
		if Input.is_action_pressed("p2_move_forward"):  # W key
			move_direction += 1
		if Input.is_action_pressed("p2_move_backward"): # S key
			move_direction -= 1

	# Apply rotation
	angular_velocity = turn_direction * rotation_speed

	# Apply movement
	if move_direction != 0:
		var forward_vector = Vector2.UP.rotated(rotation)
		apply_central_force(forward_vector * thrust * move_direction)
