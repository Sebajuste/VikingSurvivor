extends CharacterState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter(msg: Dictionary = {}):
	super.enter(msg)
	character.object_detection.connect("object_detected", _on_body_detected)
	


func exit():
	super.exit()
	character.object_detection.disconnect("object_detected", _on_body_detected)


func _on_body_detected(object: Node3D):
	
	if not object.is_in_group("item_pickable"):
		return
	
	var object_inventory : Inventory = object.inventory
	if object_inventory.transfer_to(character.inventory):
		var end_handler = func():
			object.queue_free()
		ObjectTweenMove.create(object, character).start(end_handler)
	
	pass
