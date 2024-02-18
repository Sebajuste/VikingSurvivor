extends SpringArm3D
class_name CameraRig

@export_enum("FPS", "TPS", "TopView") var mode := "FPS":
	set(value):
		mode = value
		_update_mode()

@export_node_path("Node3D") var target_path

@export_group("Speed", "speed_")
@export var speed_move = 10.0
@export var speed_rotation := 10.0

@export var up_direction := Vector3.UP:
	set(value):
		up_direction = value.normalized()


@export_group("TopView", "top_view")
@export var top_view_target_offset := Vector3.ZERO
@export var top_view_view_offset := Vector3.ZERO


@onready var spring = self
@onready var camera = $Camera3D
@onready var state_machine := $StateMachine

@onready var top_view := $StateMachine/TopView

var _target_ref : WeakRef = weakref(null)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if target_path:
		var node = get_node_or_null(target_path)
		if node.has_method("get_camera_attach_node"):
			node = node.get_camera_attach_node()
		set_target( node )
	
	top_view.target_offset = top_view_target_offset
	top_view.view_offset = top_view_view_offset
	
	_update_mode()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _update_mode():
	if not state_machine:
		return
	state_machine.transition_to(mode)
	
	pass


func set_target(target):
	_target_ref = weakref(target)
	if target:
		spring.add_excluded_object(target)
	pass


func get_target() -> Node3D:
	return _target_ref.get_ref()
