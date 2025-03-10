extends RigidBody2D

enum PlayerType {PLAYER_1, PLAYER_2}

@export var p1_sprite: SpriteFrames
@export var p2_sprite: SpriteFrames

@export var ball_scene: PackedScene
@export var spawn_offset: Vector2 = Vector2(0, -50)

@export var rotation_speed: float = 3.0  # Rotation speed in radians per second
@export var thrust: float = 300.0        # Force applied when moving forward/backward
@export var player_type: PlayerType = PlayerType.PLAYER_1
@export var has_ball: bool = false
@export var is_in_control: bool = false

@export var dash_sfx: AudioStream
@export var swing_sfx: AudioStream

var has_played_swing_sound = false

var is_charging: bool = false
var charge_time: float = 0.0
var max_charge: float = 2.0
var charge_coef: float = 100
var base_throw_magnitude: float = 200

var is_goalie: bool = false
var x_lock: float = 0.0
var dash_time: float = 4.0

func play_dash_sound():
	AudioManager.play_sfx(dash_sfx, 1.0)
	
func play_swing_sound():
	AudioManager.play_sfx(swing_sfx, 1.0)

func do_dash(move_direction: int):
	var forward_vector = Vector2.UP.rotated(rotation)
	linear_velocity += 150 * move_direction * forward_vector
	play_dash_sound()

func _integrate_forces(state: PhysicsDirectBodyState2D):
	sleeping = false
	if is_in_control:
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
			if player_type == PlayerType.PLAYER_1 and \
			Input.is_action_just_pressed("p1_dash") and Globals.p1_dash_time == 0.0:
				Globals.p1_dash_time = dash_time
				do_dash(move_direction)
			elif player_type == PlayerType.PLAYER_2 and \
			Input.is_action_just_pressed("p2_dash") and Globals.p2_dash_time == 0.0:
				Globals.p2_dash_time = dash_time
				do_dash(move_direction)
			else:
				var forward_vector = Vector2.UP.rotated(rotation)
				var move_force = forward_vector * thrust * move_direction
				if is_goalie:
					move_force.x = 0
				apply_central_force(move_force)

	if is_goalie:
		var new_velocity = state.linear_velocity
		new_velocity.x = 0  # Prevent X movement
		state.linear_velocity = new_velocity
		
		# Lock X position
		var new_transform = state.transform
		new_transform.origin.x = x_lock  # Keep X fixed
		state.transform = new_transform

func reflect_across_y(target: Transform2D) -> Transform2D:
	var reflected_pos = Vector2(-target.origin.x, target.origin.y)
	var reflected_x = Vector2(-target.x.x, target.x.y)
	var reflected_y = Vector2(-target.y.x, target.y.y)
	var reflected_basis = Transform2D(reflected_x, reflected_y, reflected_pos)
	return reflected_basis

func _ready():
	if not is_in_control:
		is_goalie = true
		x_lock = global_position.x
		
	contact_monitor = true
	max_contacts_reported = 1
	
	if player_type == PlayerType.PLAYER_1:
		$AnimatedSprite2D.sprite_frames = p1_sprite
		if has_ball:
			$AnimatedSprite2D.play("ball")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.transform = reflect_across_y($AnimatedSprite2D.transform)
		$CollisionShape2D.transform = reflect_across_y($CollisionShape2D.transform)
		$ShootSpawn.transform = reflect_across_y($ShootSpawn.transform)
		$Area2D/CollisionPolygon2D.transform = reflect_across_y($Area2D/CollisionPolygon2D.transform)
		
		$AnimatedSprite2D.sprite_frames = p2_sprite
		if has_ball:
			$AnimatedSprite2D.play("ball")
		else:
			$AnimatedSprite2D.play("idle")
		
func _process(delta: float) -> void:
	#if player_type == PlayerType.PLAYER_2:
	#	print(transform)
	if player_type == PlayerType.PLAYER_1 and Input.is_action_just_pressed("p1_swap"):
		if is_charging:
			is_charging = false
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			$AnimatedSprite2D.play()
			Globals.p1_charge_percent = 0.0
		is_in_control = not is_in_control
		
	elif player_type == PlayerType.PLAYER_2 and Input.is_action_just_pressed("p2_swap"):
		if is_charging:
			is_charging = false
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			$AnimatedSprite2D.play()
			Globals.p2_charge_percent = 0.0 
		is_in_control = not is_in_control
	
	if $AnimatedSprite2D.animation == "throw" and \
		(player_type == PlayerType.PLAYER_1 and Input.is_action_just_released("p1_shoot_ball") or \
		player_type == PlayerType.PLAYER_2 and Input.is_action_just_released("p2_shoot_ball")):
			is_charging = false
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			$AnimatedSprite2D.play()
			if player_type == PlayerType.PLAYER_1:
				Globals.p1_charge_percent = 0.0
			else:
				Globals.p2_charge_percent = 0.0
			
	elif is_charging:
		charge_time += delta
		if charge_time > max_charge:
			charge_time = max_charge
		if player_type == PlayerType.PLAYER_1:
			Globals.p1_charge_percent = charge_time / max_charge
		else:
			Globals.p2_charge_percent = charge_time / max_charge
	
	if is_in_control:
		if has_ball and $AnimatedSprite2D.animation == "ball":
			if player_type == PlayerType.PLAYER_1 and Input.is_action_just_pressed("p1_shoot_ball"):
				$AnimatedSprite2D.play("throw")
				is_charging = true
				
			elif player_type == PlayerType.PLAYER_2 and Input.is_action_just_pressed("p2_shoot_ball"):
				$AnimatedSprite2D.play("throw")
				is_charging = true
		elif not has_ball and $AnimatedSprite2D.animation == "idle":
			if player_type == PlayerType.PLAYER_1 and Input.is_action_just_pressed("p1_shoot_ball"):
				$AnimatedSprite2D.play("steal")
				
			elif player_type == PlayerType.PLAYER_2 and Input.is_action_just_pressed("p2_shoot_ball"):
				$AnimatedSprite2D.play("steal")
		

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "throw":
		
		if $AnimatedSprite2D.frame == 4 and is_charging:
			$AnimatedSprite2D.pause()
			has_played_swing_sound = false
			
		elif $AnimatedSprite2D.frame == 5:
			play_swing_sound()
			has_played_swing_sound = true
		
		elif $AnimatedSprite2D.frame == 6:
			var space_state = get_world_2d().direct_space_state  # Get physics space
			# Create a small collision shape for checking (like a tiny circle)
			var shape = CircleShape2D.new()
			shape.radius = 8  # Adjust this to match the ball size

			# Set up query parameters
			var query_params = PhysicsShapeQueryParameters2D.new()
			query_params.shape = shape
			query_params.transform = global_transform * $ShootSpawn.transform
			query_params.collision_mask = 1  # Only check against walls (layer 1)

			# Check for collisions
			var result = space_state.intersect_shape(query_params)

			if result.size() == 0:  # No walls detected at the spawn position
				has_ball = false
				var ball_instance = ball_scene.instantiate()
				var ball_rb = ball_instance.get_node("RigidBody2D")
				ball_rb.transform = Transform2D(transform)
				ball_rb.transform *= $ShootSpawn.transform
				var facing_direction = ball_rb.transform.y.normalized()
				ball_rb.linear_velocity = facing_direction * (base_throw_magnitude + charge_coef * charge_time)
				ball_rb.linear_velocity += linear_velocity.project(ball_rb.linear_velocity)
				
				get_parent().add_child(ball_instance)
			
		elif $AnimatedSprite2D.frame == 8:
			if has_ball:
				$AnimatedSprite2D.play("ball")
			else:
				$AnimatedSprite2D.play("idle")
				
			$AnimatedSprite2D.speed_scale = 1.0
			charge_time = 0.0
	
	elif $AnimatedSprite2D.animation == "steal":
		if $AnimatedSprite2D.frame == 4:
			$Area2D.get_node("CollisionPolygon2D").disabled = false
			has_played_swing_sound = false
			
		elif $AnimatedSprite2D.frame == 5:
			if not has_played_swing_sound:
				play_swing_sound()
				has_played_swing_sound = true
		
		elif $AnimatedSprite2D.frame == 8:
			$Area2D.get_node("CollisionPolygon2D").disabled = true
			if has_ball:
				$AnimatedSprite2D.play("ball")
			else:
				$AnimatedSprite2D.play("idle")
			
				
	elif $AnimatedSprite2D.animation == "empty_throw":
		if $AnimatedSprite2D.frame == 4:
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			has_played_swing_sound = false
			
		elif $AnimatedSprite2D.frame == 5:
			if not has_played_swing_sound:
				play_swing_sound()
				has_played_swing_sound = true
			
		elif $AnimatedSprite2D.frame == 8:
			$AnimatedSprite2D.play("idle")
			$AnimatedSprite2D.speed_scale = 1.0
			charge_time = 0.0
			

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("ball"):
		body.queue_free()
		has_ball = true
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if not has_ball and body.is_in_group("player") and body.has_ball:
		has_ball = true
		body.has_ball = false
		
		var anim = body.get_node("AnimatedSprite2D")
		if anim.animation == "throw":
			if body.is_charge:
				body.is_charging = false
				if body.player_type == PlayerType.PLAYER_1:
					Globals.p1_charge_percent = 0.0
				else:
					Globals.p2_charge_percent = 0.0
			
			var current_frame = anim.frame
			anim.play("empty_throw")
			anim.frame = current_frame
			if anim.frame >= 4:
				anim.speed_scale += 2 * body.charge_time / body.max_charge
		else:
			anim.play("idle")
