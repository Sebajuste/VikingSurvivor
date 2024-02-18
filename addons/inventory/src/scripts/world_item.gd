@tool
extends Node3D
class_name WorldItem

@export var shape : Shape3D
@export var item : GameItem
#@export var model : PackedScene

@onready var collision_shape = $Area3D/CollisionShape3D
@onready var inventory : Inventory = $InventoryList

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#add_to_group("item_pickable")
	
	if Engine.is_editor_hint():
		if item:
			var scene = item.model.instantiate()
			collision_shape.add_child(scene)
		return
	
	collision_shape.shape = shape
	
	if inventory.size() > 0:
		push_warning("Invalid WorldItem")
		return
	
	if item:
		inventory.add_item(item.duplicate())
		var scene = item.model.instantiate()
		collision_shape.add_child(scene)
	else:
		push_warning("Invalid GameItem")
	


func add_item(item: GameItem):
	if inventory.size() > 0:
		push_warning("Invalid WorldItem")
		return
	inventory.add_item(item)
