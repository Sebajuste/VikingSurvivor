extends MarginContainer

const ITEM_SCENE = preload("res://core/gui/scenes/gui_inventory_item.tscn")

@export var inventory : Inventory:
	set(value):
		_update_inventory(inventory, value)
		inventory = value

@onready var item_list = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_inventory(null, inventory)
	pass # Replace with function body.


func _update_inventory(old_inventory: Inventory, new_inventory: Inventory):
	
	# TODO : remove old callback
	if old_inventory:
		old_inventory.disconnect("changed", _on_inventory_changed)
	
	# TODO : add new callback
	if new_inventory:
		new_inventory.connect("changed", _on_inventory_changed)
	
	rebuild()

func rebuild():
	for item in item_list.get_children():
		item.queue_free()
	
	if not inventory:
		self.visible = false
		return
	
	for slot_id in inventory.size():
		var item = inventory.get_item(slot_id)
		var gui_item = ITEM_SCENE.instantiate()
		item_list.add_child(gui_item)
		gui_item.set_item(item)
	
	self.visible = not inventory.is_empty()
	

func _on_inventory_changed():
	
	rebuild()
	pass
