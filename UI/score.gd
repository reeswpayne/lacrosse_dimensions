extends Control


@onready var team_1_score = $"Text/HBoxContainer/Team 1 Score"
@onready var team_2_score = $"Text/HBoxContainer/Team 2 Score"
@onready var timer_time = $Text/HBoxContainer/Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_game():
	team_1_score.text = "0"
	team_2_score.text = "0"
	timer_time.text = "3:00"
	
	
