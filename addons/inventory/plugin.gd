@tool
extends EditorPlugin


func _enter_tree():
	
	add_custom_type(
		"InventoryList",
		"Node",
		preload("./src/scripts/inventory_list.gd"),
		null
	)
	
	add_custom_type(
		"InventoryGrid",
		"Node",
		preload("./src/scripts/inventory_grid.gd"),
		null
	)
	
	add_custom_type(
		"WorldItem",
		"Area3D",
		preload("./src/scripts/world_item.gd"),
		null
	)
	
	pass


func _exit_tree():
	
	remove_custom_type("InventoryList")
	remove_custom_type("InventoryGrid")
	
	remove_custom_type("WorldItem")
	
	pass
