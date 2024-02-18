extends Inventory
class_name InventoryGrid



var _items : Dictionary = {}


func has_item(slot_id:int) -> bool:
	
	return _items.has(slot_id)
	

func get_item(slot_id:int) -> GameItem:
	if has_item(slot_id):
		return _items.get(slot_id)
	return null

func get_next_free_slot() -> int:
	for slot_id in range(max_slot):
		if not has_item(slot_id):
			return slot_id
	return -1


func add_item(item:GameItem, _quantity := -1, slot_id : int = -1) -> bool:
	
	if is_full():
		return false
	
	if slot_id == -1:
		slot_id = get_next_free_slot()
	
	if not has_item(slot_id): # si le slot est libre
		_items[slot_id] = item
		item_added.emit(slot_id, item)
		changed.emit()
		return true
	else: # Si le slot est occupé
		if _items[slot_id].object_type == item.object_type and item.is_stackable():
			var new_quantity = _items[slot_id].quantity + item.quantity
			if new_quantity <  _items[slot_id].max_stack:
				_items[slot_id].quantity = new_quantity
				item_added.emit(_items[slot_id], slot_id)
				changed.emit()
				return true
	return false

# Supprime l'objet de l'inventaire. La fonction retourne l'item supprimé
func remove_item(slot_id : int, amount : int = -1) -> GameItem:
	
	if has_item(slot_id):
		var item = _items[slot_id]
		_items.erase(slot_id)
		item_removed.emit(item, slot_id)
		changed.emit()
		return item
	
	return null
