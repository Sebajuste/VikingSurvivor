extends Node3D

@onready var ice_screen = $IceScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_h_slider_value_changed(value):
	ice_screen.intensity = value
	pass # Replace with function body.
