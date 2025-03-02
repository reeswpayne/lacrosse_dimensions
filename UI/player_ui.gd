extends Control

var r_off_start
var r_off_target
var r_def_start
var r_def_target
var b_off_start
var b_off_target
var b_def_start
var b_def_target

var t_r = 0
var t_b = 0

var swap_r = false
var swap_b = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TeamBG/SelectedIcons/RedD.modulate.v = .7
	$TeamBG/SelectedIcons/BlueD.modulate.v = .7


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("p1_swap"):
		r_swap()
	if Input.is_action_just_pressed("p2_swap"):
		b_swap()
	
	if swap_r:
		t_r += .05
		$TeamBG/SelectedIcons/RedO.position = r_off_start.lerp(r_off_target, t_r)
		$TeamBG/SelectedIcons/RedD.position = r_def_start.lerp(r_def_target, t_b)
		if r_swap_d:
			$TeamBG/SelectedIcons/RedD.scale -= Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/RedO.scale += Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/RedD.modulate.v -= .3*.05
			$TeamBG/SelectedIcons/RedO.modulate.v += .3*.05
		elif r_swap_o:
			$TeamBG/SelectedIcons/RedD.scale += Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/RedO.scale -= Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/RedD.modulate.v += .3*.05
			$TeamBG/SelectedIcons/RedO.modulate.v -= .3*.05

	if t_r > 1:
		t_r = 0
		swap_r = false
		
	if swap_b:
		t_b += .05
		$TeamBG/SelectedIcons/BlueO.position = b_off_start.lerp(b_off_target, t_b)
		$TeamBG/SelectedIcons/BlueD.position = b_def_start.lerp(b_def_target, t_b)
		if b_swap_d:
			$TeamBG/SelectedIcons/BlueD.scale -= Vector2(-.1*.05, .1*.05)
			$TeamBG/SelectedIcons/BlueO.scale += Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/BlueD.modulate.v -= .3*.05
			$TeamBG/SelectedIcons/BlueO.modulate.v += .3*.05
		elif b_swap_o:
			$TeamBG/SelectedIcons/BlueD.scale += Vector2(-.1*.05, .1*.05)
			$TeamBG/SelectedIcons/BlueO.scale -= Vector2(.1*.05, .1*.05)
			$TeamBG/SelectedIcons/BlueD.modulate.v += .3*.05
			$TeamBG/SelectedIcons/BlueO.modulate.v -= .3*.05

	if t_b > 1:
		t_b = 0
		swap_b = false
		
	


var r_swap_o = false
var r_swap_d = true
var b_swap_o = false
var b_swap_d = true

func r_swap():
	if r_swap_d:
		r_off_start = Vector2(40, 1010)
		r_off_target = Vector2(120, 1050)
		r_def_start = Vector2(120, 1050)
		r_def_target = Vector2(40, 1010)
		$TeamBG/SelectedIcons/RedO.scale = Vector2(.2, .2)
		$TeamBG/SelectedIcons/RedD.scale = Vector2(.1, .1)
		$TeamBG/SelectedIcons/RedO.modulate.v = 1
		$TeamBG/SelectedIcons/RedD.modulate.v = .7
		r_swap_o = true
		r_swap_d = false
		
	elif r_swap_o:
		r_off_start = Vector2(120, 1050)
		r_off_target = Vector2(40, 1010)
		r_def_start = Vector2(40, 1010)
		r_def_target = Vector2(120, 1050)
		$TeamBG/SelectedIcons/RedD.scale = Vector2(.2, .2)
		$TeamBG/SelectedIcons/RedO.scale = Vector2(.1, .1)
		$TeamBG/SelectedIcons/RedO.modulate.v = .7
		$TeamBG/SelectedIcons/RedD.modulate.v = 1
		r_swap_o = false
		r_swap_d = true
	swap_r = true

func b_swap():
	if b_swap_d:
		b_off_start = Vector2(1880, 1010)
		b_off_target = Vector2(1800, 1050)
		b_def_start = Vector2(1800, 1050)
		b_def_target = Vector2(1880, 1010)
		$TeamBG/SelectedIcons/BlueO.scale = Vector2(.2, .2)
		$TeamBG/SelectedIcons/BlueD.scale = Vector2(-.1, .1)
		$TeamBG/SelectedIcons/BlueO.modulate.v = 1
		$TeamBG/SelectedIcons/BlueD.modulate.v = .7
		b_swap_o = true
		b_swap_d = false
	elif b_swap_o:
		b_off_start = Vector2(1800, 1050)
		b_off_target = Vector2(1880, 1010)
		b_def_start = Vector2(1880, 1010)
		b_def_target = Vector2(1800, 1050)
		$TeamBG/SelectedIcons/BlueD.scale = Vector2(-.2, .2)
		$TeamBG/SelectedIcons/BlueO.scale = Vector2(.1, .1)
		$TeamBG/SelectedIcons/BlueO.modulate.v = .7
		$TeamBG/SelectedIcons/BlueD.modulate.v = 1
		
		b_swap_o = false
		b_swap_d = true
	swap_b = true



func _on_button_pressed() -> void:
	r_swap()
	b_swap()
