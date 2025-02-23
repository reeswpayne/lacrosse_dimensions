extends Node2D

# loads the player scene 
@onready var ball_base = preload("res://objects/ball/ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var ball = ball_base.instantiate()
	ball.position = Vector2(100,450)
	add_child(ball)
	set_process_input(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
