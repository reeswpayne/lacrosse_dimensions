extends StaticBody2D

@export var player = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_base_level_create_goal(playernum):
	if player != 0 :
		player = playernum
		print(playernum)
		
func create_goal(playernum):
	if player == 0 :
		player = playernum
		#print(playernum)
		
func update_points():
	if player == 1:
		get_node("/root/globas").p1_score = get_node("/root/globas").p1_score + 1
		print(get_node("/root/globas").p1_score)
	else:
		get_node("/root/globas").p2_score = get_node("/root/globas").p2_score + 1
		print(get_node("/root/globas").p2_score)
	
