extends GridContainer
class_name GUIInventory


const SLOT_SCENE = preload("res://core/miscs/inventory/gui/inventory_slot.tscn")


@export_node_path("Inventory") var inventory

var _inventory: Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_inventory( get_node(inventory) )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_inventory(inventory : Inventory):
	if _inventory:
		_inventory.changed.disconnect(update)
	_inventory = inventory
	_inventory.changed.connect(update)
	update()

func update():
	print("update")
	for child in get_children():
		child.queue_free()
	
	for slot_id in range(_inventory.max_slot):
		
		var inventory_slot : GUIInventorySlot = SLOT_SCENE.instantiate()
		add_child(inventory_slot)
		
		if _inventory.has_item(slot_id):
			var item = _inventory.get_item(slot_id)
			inventory_slot.item = item
		
	
	
	
	pass
