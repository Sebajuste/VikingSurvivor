extends Node3D
class_name GUIRecipeRequirements

const ITEM_SCENE = preload("res://core/actors/workshop/gui/gui_item_requirement.tscn")

@export var craft : CraftAbstract

@onready var item_list = $Texture/SubViewport/Control/ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update():
	if not craft:
		return
	
	for item in item_list.get_children():
		item.queue_free()
	
	for input in craft.build_recipe.inputs:
		
		var require = input.quantity
		var quantity := 0
		
		var slot_id := craft.inventory.find_item(input.item)
		if slot_id != -1:
			var item = craft.inventory.get_item(slot_id)
			quantity = item.quantity
		
		var gui_item = ITEM_SCENE.instantiate()
		gui_item.item_scene = input.item.model
		gui_item.require = require
		gui_item.quantity = quantity
		
		item_list.add_child(gui_item)
		
	
	pass
