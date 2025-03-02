extends Node

var p1_score = 0
var p2_score = 0

var p1_dash_time = 0.0
var p2_dash_time = 0.0

var p1_charge_percent = 0.0
var p2_charge_percent = 0.0

func _process(delta: float) -> void:
	if p1_dash_time > 0.0:
		p1_dash_time -= delta
	if p1_dash_time < 0.0:
		p1_dash_time = 0.0
	
	if p2_dash_time > 0.0:
		p2_dash_time -= delta
	if p2_dash_time < 0.0:
		p2_dash_time = 0.0
