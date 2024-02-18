# @tool
extends Node
class_name State


@onready var _state_machine : StateMachine = _get_state_machine(self)


var _parent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	var parent = get_parent()
	if not parent.is_in_group("state_machine"):
		_parent = parent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta : float):
	if _parent:
		_parent.process(delta)


func physics_process(delta : float):
	if _parent:
		_parent.physics_process(delta)


func input(event: InputEvent):
	if _parent:
		_parent.input(event)


func unhandled_input(event: InputEvent):
	if _parent:
		_parent.unhandled_input(event)


func enter(msg: Dictionary = {}):
	if _parent:
		_parent.enter(msg)


func exit():
	if _parent:
		_parent.exit()

func _get_state_machine(node : Node):
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
