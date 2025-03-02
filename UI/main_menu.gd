extends Node2D

@onready var camera = $Camera2D

@export var click_sfx: AudioStream

var camera_start
var camera_target
var camera_timer = 0
var in_transition = false

func _ready() -> void:
	camera_target = $StartScreen.position
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_transition:
		camera_timer += 0.02
		camera.position = camera_start.cubic_interpolate(camera_target, Vector2(0.37, 0), Vector2(0.63, 1), camera_timer)
		
	
	if camera_timer > 1:
		camera_timer = 0
		in_transition = false
		print("end transition")


func _on_start_button_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $LevelSelect.position
	in_transition = true


func _on_htp_button_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $HowToPlay.position
	in_transition = true


func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $Credits.position
	in_transition = true


func _on_quit_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	get_tree().quit()


func _on_m_2_back_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $StartScreen.position
	in_transition = true


func _on_m_3_back_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $StartScreen.position
	in_transition = true


func _on_m_4_back_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	camera_start = camera.position
	camera_target = $StartScreen.position
	in_transition = true

func _on_m_1_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_m_2_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	get_tree().change_scene_to_file("res://levels/level_2.tscn")


func _on_m_3_pressed() -> void:
	AudioManager.play_sfx(click_sfx, 0.5)
	get_tree().change_scene_to_file("res://levels/level_3.tscn")
