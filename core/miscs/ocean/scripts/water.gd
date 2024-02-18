extends MeshInstance3D


@export var height := 4.0:
	set(value):
		height = value
		_update_shader()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_update_shader()
	
	pass # Replace with function body.


func _update_shader():
	
	material_override.set("shader_parameter/height_scale", height)
	

