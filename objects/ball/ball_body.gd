extends RigidBody2D

const respawn = [Vector2(300,400),Vector2(300,100),Vector2(500,400),Vector2(500,100)]

var reset_state = false
var moveVector: Vector2

var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	apply_impulse(Vector2(200,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

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
		body.update_points()
		move_body(Vector2(-500,-500))
		await get_tree().create_timer(2.0).timeout
		var rand_respawn = rng.randi_range(0,3)
		move_body(respawn[rand_respawn])
	pass # Replace with function body.
