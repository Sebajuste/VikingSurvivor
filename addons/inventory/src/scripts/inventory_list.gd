extends Inventory
class_name InventoryList


@export var _items : Array[GameItem] = []

func size() -> int:
	return _items.size()

func has_item(slot_id:int) -> bool:
	
	return slot_id < _items.size()
	

func get_item(slot_id:int) -> GameItem:
	if has_item(slot_id):
		return _items[slot_id]
	return null

func find_item(item: GameItem) -> int:
	for index in range(_items.size()):
		var it = _items[index]
		if it.object_type == item.object_type and it.name == item.name:
			return index
	return -1

func add_item(item:GameItem, quantity := -1, _slot_id : int = -1) -> bool:
	if is_full() and not item.is_stackable():
		push_warning("Cannot add, inventory is full")
		return false
	
	if item.is_stackable():
		quantity = item.quantity if quantity == -1 else min(quantity, item.quantity)
		var item_index = find_item(item)
		if item_index >= 0:
			var dest_item = get_item(item_index)
			var old_quantity = dest_item.quantity
			var amount = min(dest_item.max_stack - dest_item.quantity, quantity)
			if amount > 0:
				dest_item.quantity += amount
				item_quantity_changed.emit(dest_item, item_index, old_quantity)
				changed.emit()
				return true
			return false
		elif not is_full():
			var amount = min(item.max_stack, quantity)
			var dest_item = item.duplicate()
			dest_item.quantity = amount
			_items.append(dest_item)
			changed.emit()
			#item.quantity -= amount
			return true
	
	if not is_full():
		_items.append(item)
		item_added.emit(item, _items.size()-1)
		changed.emit()
		return true
	return false

func remove_item(slot_id : int, amount : int = -1) -> GameItem:
	
	if not has_item(slot_id):
		return null
	
	var item = _items[slot_id]
	if amount == -1 or not item.is_stackable() or item.quantity == amount:
		_items.erase(item)
		item_removed.emit(item, -1)
		changed.emit()
	else:
		var old_quantity = item.quantity
		item.quantity -= amount
		item_quantity_changed.emit(item, slot_id, old_quantity)
		changed.emit()
	
	return item

func transfer_item_to(item: GameItem, other: Inventory, quantity := -1) -> bool:
	var slot_id = find_item(item)
	if slot_id == -1:
		return false
	item = get_item(slot_id)
	
	if quantity == -1:
		quantity = item.quantity
	
	if item.is_stackable():
		var other_slot_id = other.find_item(item)
		if other_slot_id != -1:
			var other_item = other.get_item(other_slot_id)
			var amount = min(other_item.max_stack - other_item.quantity, quantity)
			if amount == 0:
				return false
			
			other.add_item(item, amount)
			remove_item(slot_id, amount)
			return true
	
	if not other.is_full():
		other.add_item(item, quantity)
		remove_item(slot_id, quantity)
		return true

	return false

func transfer_to(other: Inventory) -> bool:
	
	if is_empty() or not other or not other.has_space(size()):
		return false
	
	for index in range(_items.size()):
		var item = _items[index]
		var slot_id := other.find_item(item)
		if slot_id != -1:
			var other_item := other.get_item(slot_id)
			var amount = min(other_item.max_stack - other_item.quantity, item.quantity)
			if amount == 0:
				# Not enough space
				return false
	
	var removed : Array[GameItem] = []
	
	for index in range(_items.size()):
		var it = _items[index]
		if other.add_item(it):
			removed.push_back(it)
	
	for item in removed:
		var slot_id := find_item(item)
		if slot_id != -1:
			remove_item(slot_id)
	
	return true
