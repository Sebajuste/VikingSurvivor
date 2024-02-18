extends AudioStreamPlayer

signal loop_finished

var _last_position := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	var position := get_playback_position()
	if position < _last_position and _last_position != 0.0:
		loop_finished.emit()
	_last_position = position
	"""
	pass
