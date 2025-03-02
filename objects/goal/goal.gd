extends StaticBody2D

@export var player = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	if player == 2:
		$Sprite2D2.flip_h = true
		$Sprite2D2.flip_v = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func create_goal(playernum):
	if player == 0 :
		player = playernum
		#print(playernum)
		
func update_points():
	if player == 2:
		Globals.p1_score = Globals.p1_score + 1
		print(Globals.p1_score)
	else:
		Globals.p2_score = Globals.p2_score + 1
		print(Globals.p2_score)
	$Sprite2D2.visible = true
	await get_tree().create_timer(3.0).timeout
	$Sprite2D2.visible = false
	
