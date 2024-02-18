extends Node
class_name MusicLoader

@export var music : AudioStream
@export var play_as_next := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if play_as_next:
		MusicManager.play_next(music)
	else:
		MusicManager.change(music)
	pass # Replace with function body.

