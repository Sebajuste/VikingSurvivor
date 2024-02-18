extends CraftAbstract
class_name CraftBuilderTemplate

@export_group("Build", "build")
#@export var build_requirement : Array[RecipeItem]
@export var build_model : PackedScene




"""
func fill(user: ActorCharacter):
	if not build_recipe:
		push_warning("No recipe to run build")
		return
	for input in build_recipe.inputs:
		var amount_required = max(0, input.quantity)
		var local_slot_id = inventory.find_item(input.item)
		if local_slot_id != -1:
			var local_item = inventory.get_item(local_slot_id)
			amount_required = max(0, input.quantity - local_item.quantity)
		
		if amount_required > 0:
			var user_slot_id = user.inventory.find_item(input.item)
			if user_slot_id != -1:
				var user_item = user.inventory.get_item(user_slot_id)
				var amount = min(amount_required, user_item.quantity)
				user.inventory.transfer_item_to(user_item, inventory, amount)
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


func execute_build():
	
	if not has_inputs_requirement():
		return
	
	super.execute_build()
	
	# Remove objects required
	for input in build_recipe.inputs:
		var slot_id = inventory.find_item(input.item)
		if slot_id != -1:
			inventory.remove_item(slot_id, input.quantity)
	
	
	var local_buildmodel = build_model.instantiate()
	
	get_parent().add_child(local_buildmodel)
	local_buildmodel.global_transform = self.global_transform
	
	queue_free()
	
	pass # Replace with function body.
