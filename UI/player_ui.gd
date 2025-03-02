extends Control

var r_off_start
var r_off_target
var r_def_start
var r_def_target
var b_off_start
var b_off_target
var b_def_start
var b_def_target

var t_r
var t_b

var swap_r_o = false
var swap_r_d = false
var swap_b_o = false
var swap_b_d = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func r_swap():
	r_off_start = $TeamBG/SelectedIcons/RedO.position
	r_off_target = $TeamBG/SelectedIcons/RedD.position
	r_def_start = $TeamBG/SelectedIcons/RedD.position
	r_def_target = $TeamBG/SelectedIcons/RedO.position


func b_swap():
	b_off_start = $TeamBG/SelectedIcons/BlueO.position
	b_off_target = $TeamBG/SelectedIcons/BlueD.position
	b_def_start = $TeamBG/SelectedIcons/BlueD.position
	b_def_target = $TeamBG/SelectedIcons/BlueO.position
