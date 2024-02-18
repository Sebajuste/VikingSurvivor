@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	
	add_custom_type(
		"StateMachine",
		"Node",
		preload("./scripts/state_machine.gd"),
		preload("./icons/state_machine.svg")
	)
	
	add_custom_type(
		"State",
		"Node",
		preload("./scripts/state.gd"),
		preload("./icons/state.svg")
	)
	
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	
	remove_custom_type("StateMachine")
	remove_custom_type("State")
	pass
