extends CharacterSkin


@onready var animation_tree = $Humanoid/AnimationTree


var locomotion_blend := 0.0

func play_idle():
	animation_tree["parameters/WalkAndRun/playback"].travel("Locomotion")
	animation_tree.set("parameters/WalkAndRun/Locomotion/Normal/blend_position", 0)
	animation_tree.set("parameters/WalkAndRun/Locomotion/Snow/blend_position", 0)
	#animation_tree.set("parameters/SwordAndShield/Locomotion/blend_position", 0)
	pass

func play_locomotion():
	animation_tree["parameters/WalkAndRun/playback"].travel("Locomotion")
	pass

func run_locomotion(velocity: Vector2, delta: float):
	var speed = velocity.length()
	
	#var fblend : float = animation_tree.get("parameters/WalkAndRun/Locomotion/Normal/blend_position")
	var fblend := lerpf(locomotion_blend, speed, delta * 10)
	
	if abs(fblend - locomotion_blend) > 0.001:
		locomotion_blend = fblend
		
		animation_tree.set("parameters/WalkAndRun/Locomotion/Normal/blend_position", locomotion_blend)
		animation_tree.set("parameters/WalkAndRun/Locomotion/Snow/blend_position", locomotion_blend)
		
	#animation_tree.set("parameters/SwordAndShield/Locomotion/blend_position", velocity)
	pass

func play_die():
	var state_machine = animation_tree["parameters/playback"]
	state_machine.travel("Death")

func start_move_sound():
	pass

func stop_move_sound():
	pass
