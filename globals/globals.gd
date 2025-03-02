extends Node

var p1_score = 0
var p2_score = 0
var match_time = 0.0

var p1_dash_time = 0.0
var p2_dash_time = 0.0

var p1_charge_percent = 0.0
var p2_charge_percent = 0.0

var p1_has_played_recharge_sound = true
var p2_has_played_recharge_sound = true

func _process(delta: float) -> void:
	if p1_dash_time > 0.0:
		p1_has_played_recharge_sound = false
		p1_dash_time -= delta
	if p1_dash_time <= 0.0:
		if not p1_has_played_recharge_sound:
			p1_has_played_recharge_sound = true
			AudioManager.play_sfx(AudioManager.recharge_sfx, 1.0)
		p1_dash_time = 0.0
	
	if p2_dash_time > 0.0:
		p2_has_played_recharge_sound = false
		p2_dash_time -= delta
	if p2_dash_time <= 0.0:
		if not p2_has_played_recharge_sound:
			p2_has_played_recharge_sound = true
			AudioManager.play_sfx(AudioManager.recharge_sfx, 1.0)
		p2_dash_time = 0.0
