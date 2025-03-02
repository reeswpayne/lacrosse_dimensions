extends RigidBody2D

enum PlayerType {PLAYER_1, PLAYER_2}
enum CharacterType {OFFENSE, DEFENSE}

@export var p1_sprite: SpriteFrames
@export var p2_sprite: SpriteFrames

@export var ball_scene: PackedScene
@export var spawn_offset: Vector2 = Vector2(0, -50)

@export var rotation_speed: float = 3.0  # Rotation speed in radians per second
@export var thrust: float = 300.0        # Force applied when moving forward/backward
@export var player_type: PlayerType = PlayerType.PLAYER_1
@export var character_type: CharacterType = CharacterType.OFFENSE
@export var has_ball: bool = false

var is_charging: bool = false
var charge_time: float = 0.0
var max_charge: float = 2.0
var charge_coef: float = 100
var base_throw_magnitude: float = 200

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
		
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	
	if player_type == PlayerType.PLAYER_1:
		$AnimatedSprite2D.sprite_frames = p1_sprite
		if has_ball:
			$AnimatedSprite2D.play("ball")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.sprite_frames = p2_sprite
		if has_ball:
			$AnimatedSprite2D.play("ball")
		else:
			$AnimatedSprite2D.play("idle")
	pass
		
func _process(delta: float) -> void:
	if $AnimatedSprite2D.animation == "throw" and \
		(player_type == PlayerType.PLAYER_1 and Input.is_action_just_released("p1_shoot_ball") or \
		player_type == PlayerType.PLAYER_2 and Input.is_action_just_released("p2_shoot_ball")):
			is_charging = false
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			$AnimatedSprite2D.play()
			
	elif is_charging:
		charge_time += delta
		if charge_time > max_charge:
			charge_time = max_charge
			
	if has_ball and $AnimatedSprite2D.animation == "ball":
		if player_type == PlayerType.PLAYER_1 and Input.is_action_just_pressed("p1_shoot_ball"):
			$AnimatedSprite2D.play("throw")
			has_ball = false
			is_charging = true
			
		elif player_type == PlayerType.PLAYER_2 and Input.is_action_just_pressed("p2_shoot_ball"):
			$AnimatedSprite2D.play("throw")
			has_ball = false
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
		
		elif $AnimatedSprite2D.frame == 6:
			var ball_instance = ball_scene.instantiate()
			var ball_rb = ball_instance.get_node("RigidBody2D")
			ball_rb.transform = Transform2D(transform)
			ball_rb.transform *= $ShootSpawn.transform
			var facing_direction = ball_rb.transform.y.normalized()
			ball_rb.linear_velocity = facing_direction * (base_throw_magnitude + charge_coef * charge_time)
			ball_rb.linear_velocity += linear_velocity.project(ball_rb.linear_velocity)
			get_parent().add_child(ball_instance)
			
		elif $AnimatedSprite2D.frame == 8:
			$AnimatedSprite2D.play("idle")
			$AnimatedSprite2D.speed_scale = 1.0
			charge_time = 0.0
	
	elif $AnimatedSprite2D.animation == "steal":
		if $AnimatedSprite2D.frame == 4:
			$Area2D.get_node("CollisionPolygon2D").set_deferred("disabled", false)
		
		elif $AnimatedSprite2D.frame == 8:
			$Area2D.get_node("CollisionPolygon2D").set_deferred("disabled", true)
			if not has_ball:
				$AnimatedSprite2D.play("idle")
				
	elif $AnimatedSprite2D.animation == "empty_throw":
		if $AnimatedSprite2D.frame == 4:
			$AnimatedSprite2D.speed_scale += 2 * charge_time / max_charge
			
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
	if body.is_in_group("player") and body.has_ball:
		var anim = body.get_node("AnimatedSprite2D")
		body.has_ball = false
		if anim.animation == "throw":
			body.is_charging = false
			
			var current_frame = anim.frame
			anim.play("empty_throw")
			anim.frame = current_frame
			if anim.frame >= 4:
				anim.speed_scale = 2 * body.charge_time / body.max_charge
		elif anim.animation != "empty_throw":
			anim.play("idle")
