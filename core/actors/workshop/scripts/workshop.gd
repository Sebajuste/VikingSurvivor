@tool
extends CraftAbstract
class_name Workshop

const build_world_item = preload("res://addons/inventory/src/scenes/world_item.tscn")

#@export var item_scene : PackedScene
#@export var visual : PackedScene
@export var running_visual : PackedScene

@export_group("Build", "build")
@export var build_auto := false
#@export var build_world_item : PackedScene

@onready var running_effect = $RunningEffect



#var _visual_item



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	if running_visual:
		running_effect.add_child( running_visual.instantiate() )
	
	running_effect.visible = false
	
	pass # Replace with function body.


"""
func fill(user: ActorCharacter):
	if not build_recipe:
		return
	for input in build_recipe.inputs:
		var slot_id = user.inventory.find_item(input.item)
		if slot_id != -1:
			var user_item = user.inventory.get_item(slot_id)
			user.inventory.transfer_item_to(user_item, self.inventory)
"""


func has_inputs_requirement() -> bool:
	if build_recipe.inputs.size() == 0:
		return false
	var has_enough_inputs := true
	
	# Check inputs requirements
	for input in build_recipe.inputs:
		var index = inventory.find_item(input.item)
		if index != -1:
			var item = inventory.get_item(index)
			if item.quantity < input.quantity:
				# Not enough quantity to build
				has_enough_inputs = false
				break
		else:
			# No item found into the inventory to build
			has_enough_inputs = false
			break
	
	return has_enough_inputs

func start():
	
	if build_recipe.inputs.size() == 0:
		return
	
	if running:
		return
	
	var has_enough_inputs := has_inputs_requirement()
	
	if has_enough_inputs:
		running = true
		timer.start()
		running_effect.visible = true
		if show_progress:
			gui_progress.visible = true
		
		for visual_item in skin.get_children():
			if visual_item.has_method("enable"):
				visual_item.enable()
		

func stop():
	timer.stop()
	running_effect.visible = false
	gui_progress.visible = false
	running = false
	
	for visual_item in skin.get_children():
			if visual_item.has_method("disable"):
				visual_item.disable()
	
	pass

func execute_build():
	
	super.execute_build()
	
	# Remove objects required
	for input in build_recipe.inputs:
		var slot_id = inventory.find_item(input.item)
		if slot_id != -1:
			inventory.remove_item(slot_id, input.quantity)
	
	# Create outputs
	for output in build_recipe.outputs:
		#var world_item = item_scene.instantiate()
		var world_item = build_world_item.instantiate()
		world_item.shape = SphereShape3D.new()
		world_item.item = output.item.duplicate()
		
		get_parent().add_child(world_item)
		
		var item = output.item.duplicate(true)
		item.quantity = output.quantity
		
		world_item.global_rotation.y = randf_range(0, PI*2)
		world_item.global_position = global_position + (Vector3.RIGHT * 2)
		if world_item is RigidBody3D:
			world_item.apply_central_impulse(Vector3.UP * 3.0)
	
	if build_auto:
		start()
	
	

