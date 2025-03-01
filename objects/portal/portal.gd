extends CanvasLayer


var output_point = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color(r, g, b, a):
	$PortalBody/CanvasModulate.color = Color(r,g,b,a)
	
func set_pos(new_pos):
	$PortalBody.position = new_pos
	
func set_output(output_vec):
	output_point = output_vec
