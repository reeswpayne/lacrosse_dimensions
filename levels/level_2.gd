extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$actual_ball/RigidBody2D.respawn = [Vector2(973,528),Vector2(973,506)]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
