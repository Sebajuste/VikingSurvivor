extends Node3D
class_name CraftAbstract

signal built()

## Shape for use
@export var shape : Shape3D

## Model used to show this object
@export var model : PackedScene
@export var model_position_offset := Vector3.ZERO
@export var show_progress := true


@export_group("Build", "build")
@export var build_recipe : Recipe
@export var build_time := 10

@onready var collision := $Area3D/CollisionShape3D
@onready var collision_player = $PlayerDetection/CollisionShape3D
@onready var skin := $Skin
@onready var gui_progress := $GUIProgress
@onready var gui_recipe_requirement : GUIRecipeRequirements = $GUIRecipeRequirements
@onready var inventory : Inventory = $InventoryList
@onready var timer := $Timer

var running := false

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape = shape
	collision_player.shape = shape
	timer.wait_time = build_time
	if model:
		var node = model.instantiate()
		node.position = model_position_offset
		skin.add_child( node )
	gui_recipe_requirement.update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if running:
		var production_progress = ((build_time - timer.time_left) / build_time) * 100
		gui_progress.percent = production_progress


func use(actor: ActorCharacter):
	if running:
		stop()
	else:
		if is_fillable(actor):
			fill(actor)
		start()

func is_fillable(user: ActorCharacter) -> bool:
	if not build_recipe:
		return false
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
				if user_item.quantity < amount_required:
					return false
			else:
				return false
	return true

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

func has_inputs_requirement() -> bool:
	return false

func start():
	if has_inputs_requirement():
		timer.start()
		running = true
		if show_progress:
			gui_progress.visible = true

func stop():
	timer.stop()
	running = false
	gui_progress.visible = false
	gui_progress.percent = 0

func execute_build():
	built.emit()
	pass

func _on_timer_timeout():
	stop()
	execute_build()
	
	pass # Replace with function body.


func _on_inventory_list_changed():
	gui_recipe_requirement.activable = has_inputs_requirement()
	gui_recipe_requirement.update()
	pass # Replace with function body.


func _on_player_detection_body_entered(body):
	gui_recipe_requirement.enable()
	print("is_fillable(body) ", is_fillable(body))
	gui_recipe_requirement.activable = has_inputs_requirement() or is_fillable(body)
	gui_recipe_requirement.update()
	pass # Replace with function body.


func _on_player_detection_body_exited(body):
	gui_recipe_requirement.disable()
	#gui_recipe_requirement.activable = has_inputs_requirement() or is_fillable(body)
	pass # Replace with function body.
