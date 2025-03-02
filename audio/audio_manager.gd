extends Node2D

@onready var music_player = $Music
@export var recharge_sfx: AudioStream

var sfx_volume = 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since th e previous frame.
func _process(delta: float) -> void:
	pass
	
	
## Plays a sound effect and destroys itself upon completion
func play_sfx(sfx_stream: AudioStream, pitch_variation := 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sfx_stream
	player.volume_db = linear_to_db(sfx_volume)
	player.finished.connect(Callable(player, "queue_free"))
	
	if (pitch_variation > 0):
		player.pitch_scale = randf_range(2**-abs(pitch_variation), 2**abs(pitch_variation))
	
	get_tree().root.add_child(player)
	player.play()
