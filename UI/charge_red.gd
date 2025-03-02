extends Polygon2D

@export var is_player_1: bool = false

var p0: Vector2
var p1: Vector2
var p2: Vector2
var p3: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p0 = Vector2(polygon[0])
	p1 = Vector2(polygon[1])
	p2 = Vector2(polygon[2])
	p3 = Vector2(polygon[3])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ratio = 0.0
	if is_player_1:
		ratio = Globals.p1_charge_percent
	else:
		ratio = Globals.p2_charge_percent
		
	polygon[3] = ratio * (p3 - p0) + p0
	polygon[2] = ratio * (p2 - p1) + p1
