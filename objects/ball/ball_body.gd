extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(200,200))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	#pply_impulse(Vector2(50,50))
	pass
