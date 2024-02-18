# @tool
class_name StateMachine
extends Node

signal state_changed(state_path, msg)

@export_node_path("State")
var initial_state : NodePath

@export
var enabled := true

@onready
var state : State = get_node_or_null(initial_state):
	set(value):
		if value and value is State:
			state = value
			state_name = state.name

var state_name : String

func _init() -> void:
	
	add_to_group("state_machine")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	if state:
		state_name = state.name
		state.enter()
	else:
		enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not enabled or not state:
		return
	state.process(delta)

func _physics_process(delta):
	if enabled and state:
		state.physics_process(delta)
	

func _input(event: InputEvent):
	if enabled and state:
		state.input(event)

func _unhandled_input(event: InputEvent):
	if enabled and state:
		state.unhandled_input(event)

func transition_to(target_state_path: String, msg: Dictionary = {}):
	
	call_deferred("process_transition", target_state_path, msg)
	

func process_transition(target_state_path: String, msg: Dictionary = {}):
	if not has_node(target_state_path):
		push_error("State %s not exists" % target_state_path )
		return
	var target_state: = get_node(target_state_path)
	
	if not target_state or self.state == target_state:
		if not target_state:
			push_error("Invalid State %s" % target_state_path)
		return
	
	if self.state:
		self.state.exit()
	self.state = target_state
	self.state.enter(msg)
	state_changed.emit(target_state_path, msg)
	# emit_signal("transitioned", target_state_path, msg)
