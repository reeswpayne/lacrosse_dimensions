extends Node2D


# loads objects
@onready var ball_base = preload("res://objects/ball/ball.tscn")
@onready var goal_p1_base = preload("res://objects/goal/goal.tscn")
@onready var portal_1a_base = preload("res://objects/portal/portal.tscn")
@onready var portal_1b_base = preload("res://objects/portal/portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	

	
	# create goal
	var goal_p1 = goal_p1_base.instantiate()
	goal_p1.position = Vector2(300,400)
	add_child(goal_p1)
	var g1 = get_tree().get_first_node_in_group("goals")
	g1.create_goal(1)
	
	# create portals
	var portal_1a = portal_1a_base.instantiate()
	# portal_1a.position = Vector2(400,100)
	add_child(portal_1a)
	var p1a = get_tree().get_first_node_in_group("portals")
	p1a.set_pos(Vector2(400,100))
	p1a.set_color(0,0,1,1)
	p1a.set_output(Vector2(400,400))
	
	var portal_1b = portal_1b_base.instantiate()
	# portal_1b.position = Vector2(400,400)
	add_child(portal_1b)
	var p1b = get_tree().get_nodes_in_group("portals")
	p1b[2].set_pos(Vector2(400,400))
	p1b[2].set_color(0,0,1,1)
	p1b[2].set_output(Vector2(400,100))
	
	# create ball
	
	var ball = ball_base.instantiate()
	ball.position = Vector2(100,450)
	ball.z_index = 0
	add_child(ball)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
