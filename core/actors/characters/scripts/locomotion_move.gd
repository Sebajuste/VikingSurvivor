extends CharacterState


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

func enter(_msg : Dictionary = {}):
	character.skin.play_locomotion()
	character.skin.start_move_sound()
	character.walk_sound.playing = true
	pass

func exit():
	character.walk_sound.playing = false
	character.skin.stop_move_sound()
	pass

func direction_to_local(transform: Transform3D, global_direction: Vector3) -> Vector3:
	var global_to_local: Transform3D = transform.affine_inverse()
	return global_to_local * global_direction - global_to_local * Vector3.ZERO


func _process(delta):
	_parent.process(delta)
	
	character.walk_sound.pitch_scale = 1.0 + randf_range(-0.5, 0.5)
	

func physics_process(delta):
	
	var local_velocity := -direction_to_local(character.global_transform, character.velocity)
	var speed := local_velocity.length()
	var local_dir := Vector2(-local_velocity.x, local_velocity.z).normalized()
	character.skin.run_locomotion(local_dir * (speed/_parent.max_speed), delta)
	
	#if character.velocity.y < -0.5:
	#	_state_machine.transition_to("Locomotion/Fall")
	
	if character.velocity.length_squared() < 0.10 and character.velocity.length_squared() >= 0:
		_state_machine.transition_to("Locomotion/Idle")
	
	_parent.physics_process(delta)
	
