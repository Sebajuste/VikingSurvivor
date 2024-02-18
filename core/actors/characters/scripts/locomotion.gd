extends CharacterState
class_name Locomotion

@export_group("Target", "target_")

## Node of the target to be attacked, join or other action
@export var target: Node3D

## If true, the character will turn to look the target
@export var target_look_at: bool = false

#var target_rotate_towards: bool = false
var _target_position := Vector3.ZERO

## Used for fall force
@export var gravity: float = 20.0

## Run speed
@export var max_speed := 2.5

## Walk speed
@export var walk_speed = 1.0

## Vector used to move the character. Updated by Inputs controller, AI, or network
@export var input_direction: Vector3 = Vector3.ZERO


var desired_speed := 0.0:
	set(val):
		desired_speed = clamp(val, 0.0, max_speed)

var move_direction: Vector3 = Vector3.ZERO
var looking_direction: Vector3 = Vector3.FORWARD
var target_look: float

var desired_velocity: Vector3 = Vector3.ZERO

var can_move: bool = true
var vertical_movement: bool = false

var _target_look: float
var _freelook_turn: bool = true
var _turn_all_the_way: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	
	character.rotation_degrees.y = wrapf(character.rotation_degrees.y, -180, 180.0)
	
	move_direction = input_direction.normalized()
	
	_update_rotation(delta)
	_update_move(delta)
	


func _update_rotation(_delta: float):
	
	var camera := get_viewport().get_camera_3d()
	
	if character.combat_mode:
		
		_freelook_turn = false
		
		var target_position := target.global_position if target else self._target_position
		
		looking_direction = character.global_position.direction_to(target_position)
		_target_look = atan2(-looking_direction.x, -looking_direction.z)
		var rotation_difference: float = abs(character.rotation.y - _target_look)
		
		var rotation_weight: float
		if rotation_difference < 0.05:
			rotation_weight = 0.2
		else:
			rotation_weight = 0.1
		
		if target and target_look_at:
			looking_direction = target.global_position.direction_to(character.global_position)
			target_look = atan2(looking_direction.x, looking_direction.z)
			character.rotation.y = lerp_angle(character.rotation.y, target_look, 0.05)
		else:
			character.rotation.y = lerp_angle(character.rotation.y, _target_look, rotation_weight)
		
		# change move direction so it orbits the locked on target
		# (not a perfect orbit, needs tuning but not unplayable)
		"""
		if move_direction.length() > 0.2:
			move_direction = move_direction.rotated(
				Vector3.UP,
				_target_look + sign(move_direction.x) * 0.13
			).normalized()
		"""
		move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y)
		
		pass
	elif input_direction.length() > 0.2:
		
		_freelook_turn = true
		_turn_all_the_way = true
		
		if can_move and desired_velocity.length() > 0:
			looking_direction = Vector3(desired_velocity.x, 0, desired_velocity.z)
		else:
			looking_direction = Vector3(input_direction.x, 0, input_direction.z)
			looking_direction = looking_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
		
		
		_target_look = atan2(-looking_direction.x, -looking_direction.z)
		
		move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y)
	
	
	if _freelook_turn and _turn_all_the_way:
		
		if abs(character.rotation.y - _target_look) < 0.01:
			_freelook_turn = false
		character.rotation.y = lerp_angle(character.rotation.y, _target_look, 0.1)
	
	if _freelook_turn and not _turn_all_the_way:
		_freelook_turn = false
		character.rotation.y = lerp_angle(character.rotation.y, _target_look, 0.03)
	

func _update_move(delta: float):
	
	if can_move:
		if move_direction.length() > 0.05:
			var weight: float = 0.2 if character.is_on_floor() else 0.1
			desired_velocity.z = lerp(desired_velocity.z, move_direction.z * desired_speed, weight)
			desired_velocity.x = lerp(desired_velocity.x, move_direction.x * desired_speed, weight)
		elif character.is_on_floor():
			var weight: float = 0.3 if vertical_movement else 0.05
			desired_velocity.x = lerp(desired_velocity.x, 0.0, weight)
			desired_velocity.z = lerp(desired_velocity.z, 0.0, weight)
	
	if not can_move and character.is_on_floor():
		desired_velocity.x = lerp(desired_velocity.x, 0.0, 0.1)
		desired_velocity.z = lerp(desired_velocity.z, 0.0, 0.1)
	
	if not character.is_on_floor():
		desired_velocity.y -= gravity * delta
	elif not vertical_movement:
		desired_velocity.y = 0
	
	character.velocity = desired_velocity
	character.move_and_slide()
