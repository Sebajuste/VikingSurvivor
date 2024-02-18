extends Node3D
class_name ObjectTweenMove


const SCENE = preload("../scenes/tween_objet_move.tscn")

signal move_finished

@export var from : Node3D
@export var target : Node3D

@onready var path : Path3D = $Path3D
@onready var path_follow := $Path3D/PathFollow3D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var _parent
var _process_mode

static func create(_from: Node3D, to: Node3D) -> ObjectTweenMove:
	var object_tween_move : ObjectTweenMove = SCENE.instantiate()
	object_tween_move.from = _from
	object_tween_move.target = to
	_from.get_parent().add_child(object_tween_move)
	return object_tween_move


# Called when the node enters the scene tree for the first time.
func _ready():
	_parent = from.get_parent()
	_process_mode = from.process_mode
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if target:
		var point = to_local(target.global_position)
		path.curve.set_point_position(1, point )
	

func start(end_handler : Callable = func(): pass):
	global_position = from.global_position
	from.get_parent().remove_child(from)
	path_follow.add_child(from)
	from.position = Vector3.ZERO
	from.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("move")
	if end_handler:
		move_finished.connect(end_handler)
	set_process(true)


func _on_animation_player_animation_finished(_anim_name):
	set_process(false)
	path_follow.remove_child(from)
	_parent.add_child(from)
	from.global_position = target.global_position
	from.process_mode = _process_mode
	move_finished.emit()
	# queue_free()
