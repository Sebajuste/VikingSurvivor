extends State


@export var target_offset := Vector3.ZERO
@export var view_offset := Vector3(0, 10, 0)

@onready var camera_rig : CameraRig = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func physics_process(_delta: float) -> void:
	
	var target := camera_rig.get_target()
	if target:
		var camera_position := target.position + view_offset
		var target_position := target.position + target_offset
		camera_rig.look_at_from_position(camera_position, target_position)
		pass
		#camera_rig.position = camera_rig.position.lerp(target.position + Vector3(0, camera_vertical_offset, 0), 0.1)
	
	pass
