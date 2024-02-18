extends State

@onready var controller : CharacterController = owner


var running := true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(_delta):
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var character = controller.get_character()
	
	if character:
		if input_dir.length_squared() > 0.2:
			character.locomotion.desired_speed = character.locomotion.max_speed if running else character.locomotion.walk_speed
		
		character.locomotion.input_direction = get_move_direction()
		
		if character.combat_mode:
			var camera_dir = -get_viewport().get_camera_3d().global_transform.basis.z
			camera_dir.y = 0
			camera_dir = camera_dir.normalized()
			character.locomotion._target_position = character.global_position + camera_dir
	
	"""
	if character and Input.is_action_just_pressed("jump"):
		character.jump()
	
	if character and Input.is_action_just_pressed("attack_primary"):
		character.attack_primary()
	
	if character and Input.is_action_just_pressed("weapon_draw"):
		character.toogle_weapon_draw()
	"""

func _unhandled_input(event):
	
	var character := controller.get_character()
	
	if character and event.is_action_pressed("use"):
		var object = character.object_detection.get_nearest()
		if object and object.has_method("use"):
			object.use(character)
	
	"""
	if character and event.is_action_pressed("weapon_block"):
		character.block(true)
	
	if character and event.is_action_released("weapon_block"):
		character.block(false)
	
	if character and event.is_action_pressed("run"):
		running = true
	
	if character and event.is_action_released("run"):
		running = false
	"""
	
	pass

func get_input_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	return Vector3(input_dir.x, 0, input_dir.y)

func get_move_direction() -> Vector3:
	var input_direction: Vector3 = get_input_direction()
	
	var camera = get_viewport().get_camera_3d()
	
	var forwards: Vector3 = camera.global_transform.basis.z * input_direction.z
	var right: Vector3 = camera.global_transform.basis.x * input_direction.x
	var dir = forwards + right
	dir.y = 0
	return dir.normalized() / input_direction.length()
