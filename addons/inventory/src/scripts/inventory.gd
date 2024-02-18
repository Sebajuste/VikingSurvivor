extends Node
class_name Inventory

signal item_added(item, slot_id)
signal item_removed(item, slot_id)
signal item_quantity_changed(item, old_quantity, slot_id)
signal changed

@export var max_slot := 16

func max_size() -> int:
	return max_slot

func has_space(space: int) -> bool:
	return max_size() - size() >= space

func is_empty() -> bool:
	return size() == 0

func is_full() -> bool:
	return max_size() == size()

func size() -> int:
	return 0

func has_item(_slot_id:int) -> bool:
	return false

func get_item(_slot_id:int) -> GameItem:
	return null

func find_item(_item: GameItem) -> int:
	return -1

func add_item(_item:GameItem, quantity := -1, _slot_id : int = -1) -> bool:
	return false

func remove_item(_slot_id : int, amount : int = -1) -> GameItem:
	return null

func transfer_item_to(item: GameItem, other: Inventory, quantity := -1) -> bool:
	return false

func transfer_to(_other: Inventory) -> bool:
	return false

