extends Control


@onready var team_1_score = $"Text/HBoxContainer/Team 1 Score"
@onready var team_2_score = $"Text/HBoxContainer/Team 2 Score"
@onready var timer_time = $Text/HBoxContainer/Timer

@export var win_sfx: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.match_time <= 0.0:
		Globals.match_time = 0.0
		if Globals.p1_score == Globals.p2_score:
			timer_time.text = "SUDDEN DEATH"
		elif Globals.p1_score > Globals.p2_score:
			AudioManager.play_sfx(win_sfx, 0.0)
			team_1_score.text = "P1 wins!"
			await get_tree().create_timer(3.0).timeout
			get_tree().change_scene_to_file("res://UI/mainMenu.tscn")
		else:
			AudioManager.play_sfx(win_sfx, 0.0)
			team_2_score.text = "P2 wins!"
			await get_tree().create_timer(3.0).timeout
			get_tree().change_scene_to_file("res://UI/mainMenu.tscn")
	else:
		team_1_score.text = str(Globals.p1_score)
		team_2_score.text = str(Globals.p2_score)
		Globals.match_time -= delta
		var minutes = int(Globals.match_time/60)
		var seconds = int(Globals.match_time) % 60
		if seconds < 10:
			timer_time.text = str(minutes) + ":0" + str(seconds)
		else:
			timer_time.text = str(minutes) + ":" + str(seconds)
		
	
	

func reset_game():
	Globals.p1_score = 0
	Globals.p2_score = 0
	Globals.match_time = 180.0
	team_1_score.text = "0"
	team_2_score.text = "0"
	timer_time.text = "3:00"
	
	
