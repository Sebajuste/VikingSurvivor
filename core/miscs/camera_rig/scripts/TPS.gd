extends State

@export_group("Camera", "camera_")
@export var camera_distance: float = 2.0
@export var camera_vertical_offset: float = 0.5
@export var camera_angle: float = 0.0
@export var camera_fov: float = 75.0

@export_category("Mouse Settings")
@export var mouse_sensitivity: float = 5.0

@onready var camera_rig : CameraRig = owner


var _lock_on_target = null
var _player_looking_around := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func enter(_msg: Dictionary = {}):
	
	camera_rig.camera.rotation_degrees.x = camera_angle
	camera_rig.camera.fov = camera_fov
	camera_rig.top_level = true
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	mouse_sensitivity = mouse_sensitivity * pow(10, -3)
	
	pass

func physics_process(_delta: float) -> void:
	
	var target = camera_rig.get_target()
	if target:
		camera_rig.position = camera_rig.position.lerp(target.position + Vector3(0, camera_vertical_offset, 0), 0.1)
	
	pass

func unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not _lock_on_target:
		_player_looking_around = true
		
		var new_rotation_x: float = camera_rig.rotation.x - event.relative.y * mouse_sensitivity
		camera_rig.rotation.x = lerp(camera_rig.rotation.x, new_rotation_x, 0.8)
		camera_rig.rotation_degrees.x = clamp(camera_rig.rotation_degrees.x, -90.0, 30.0)
		
		var new_rotation_y: float = camera_rig.rotation.y - event.relative.x * mouse_sensitivity
		camera_rig.rotation.y = lerp(camera_rig.rotation.y, new_rotation_y, 0.8)
		camera_rig.rotation_degrees.y = wrapf(camera_rig.rotation_degrees.y, 0.0, 360.0)
	else:
		_player_looking_around = false
