extends CanvasLayer

@export_range(0.0, 3.0) var intensity := 0.0:
	set(value):
		var old_value = intensity
		intensity = value
		if old_value != value:
			_update_material()
@export_range(0.0, 1.0) var distortion := 0.2

@onready var rect = $ColorRect

var _material = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_material = rect.material
	_update_material()
	pass # Replace with function body.


func _update_material():
	if not _material:
		return
	_material.set("shader_parameter/intensity", intensity)
	_material.set("shader_parameter/distortion_blend", intensity * distortion)
