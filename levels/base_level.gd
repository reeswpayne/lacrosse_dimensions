extends Node2D


# loads objects
@onready var ball_base = preload("res://objects/ball/ball.tscn")
@onready var goal_p1_base = preload("res://objects/goal/goal.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	# create ball
	
	var ball = ball_base.instantiate()
	ball.position = Vector2(100,450)
	add_child(ball)
	
	# create goal
	var goal_p1 = goal_p1_base.instantiate()
	goal_p1.position = Vector2(300,400)
	add_child(goal_p1)
	var p1 = get_tree().get_first_node_in_group("goals")
	p1.create_goal(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
