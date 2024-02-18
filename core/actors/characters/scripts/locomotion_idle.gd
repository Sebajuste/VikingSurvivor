extends CharacterState


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


func enter(_msg : Dictionary = {}):
	character.skin.play_idle()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	
	if character.velocity.length_squared() >= 0.2:
		_state_machine.transition_to("Locomotion/Move")
	
	character.skin.run_locomotion(Vector2.ZERO, delta)
	
	_parent.physics_process(delta)
	
	pass
