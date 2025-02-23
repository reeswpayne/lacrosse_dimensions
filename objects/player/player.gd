extends RigidBody2D

@export var rotation_speed: float = 3.0  # Rotation speed in radians per second
@export var thrust: float = 300.0        # Force applied when moving forward/backward

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var turn_direction = 0
	var move_direction = 0

	if Input.is_action_pressed("rot_clockwise"):  # D key
		turn_direction += 1
	if Input.is_action_pressed("rot_counterclockwise"):   # A key
		turn_direction -= 1
	if Input.is_action_pressed("move_forward"):  # W key
		move_direction += 1
	if Input.is_action_pressed("move_backward"): # S key
		move_direction -= 1

	# Apply rotation
	angular_velocity = turn_direction * rotation_speed

	# Apply movement
	if move_direction != 0:
		var forward_vector = Vector2.UP.rotated(rotation)
		apply_central_force(forward_vector * thrust * move_direction)
