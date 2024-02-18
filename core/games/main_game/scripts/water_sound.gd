extends Node3D

@export var curve : Curve
@export var target : Node3D
@export var max_distance := 512
@export var min_db := -40.0

@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var dist := target.global_position.distance_to(self.global_position)
	
	var level = curve.sample(dist / max_distance)
	
	audio.volume_db = min_db + (min_db * -level)
	
	pass
