extends CharacterState

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

func enter(_msg : Dictionary = {}):
	character.skin.play_die()
	_parent.can_move = false
	pass

func physics_process(delta):
	
	if not _parent.can_move and character.is_on_floor():
		_parent.desired_velocity.x = lerp(_parent.desired_velocity.x, 0.0, 0.1)
		_parent.desired_velocity.z = lerp(_parent.desired_velocity.z, 0.0, 0.1)
	
	if not character.is_on_floor():
		_parent.desired_velocity.y -= _parent.gravity * delta
	elif not _parent.vertical_movement:
		_parent.desired_velocity.y = 0
	
	character.velocity = _parent.desired_velocity
	character.move_and_slide()
