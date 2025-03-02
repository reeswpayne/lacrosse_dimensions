extends RigidBody2D

@export var respawn = [Vector2(960,370),Vector2(960,770)]

@export var bounce_sfx: AudioStream
@export var portal_sfx: AudioStream
@export var goal_sfx: AudioStream

var reset_state = false
var moveVector: Vector2

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var facing_direction = -1 * transform.y.normalized()
	var angle_difference = facing_direction.angle_to(linear_velocity)
	$AnimatedSprite2D.rotation = angle_difference
	
	if linear_velocity.length() < 0.5:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("default")

func _physics_process(delta):
	#pply_impulse(Vector2(50,50))
	pass

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0,moveVector)
		reset_state = false
		
func move_body(targetPos: Vector2):
	moveVector = targetPos
	reset_state = true

func _on_body_entered(body):
	if body.is_in_group("goals"):
		AudioManager.play_sfx(goal_sfx, 0.0)
		body.update_points()
		move_body(Vector2(-500000,-500000))
		await get_tree().create_timer(2.0).timeout
		var rand_respawn = rng.randi_range(0,respawn.size()-1)
		move_body(respawn[rand_respawn])
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
	if body.is_in_group("portals"):
		AudioManager.play_sfx(portal_sfx, 1.0)
		move_body(body.output_point)
		#$CollisionShape2D.set_deferred("disabled", true)
		#await get_tree().create_timer(0.5).timeout
		#$CollisionShape2D.set_deferred("disabled", false)
	else:
		AudioManager.play_sfx(bounce_sfx, 1.0)
