extends Area3D

signal object_detected(object)
signal objet_undetected(object)

@onready var character : ActorCharacter = owner

var object_refs : Array[WeakRef] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func clean():
	for ref in object_refs:
		if ref.get_ref() == null:
			object_refs.erase(ref)

func get_objects() -> Array[Node3D]:
	clean()
	var result : Array[Node3D] = []
	for ref in object_refs:
		result.append(ref.get_ref())
	return result

func get_nearest() -> Node3D:
	clean()
	var nearest_object = null
	var nearest_distance = null
	for ref in object_refs:
		var object : Node3D = ref.get_ref()
		if nearest_object == null:
			nearest_object = object
			nearest_distance = object.global_position.distance_squared_to(character.global_position)
		else:
			var distance_squared := object.global_position.distance_squared_to(character.global_position)
			if distance_squared < nearest_distance:
				nearest_object = object
				nearest_distance = distance_squared
		pass
	return nearest_object

func has_object(object):
	for ref in object_refs:
		if ref.get_ref() == object:
			return true


func _on_area_entered(area):
	var object = area.get_parent()
	if not has_object(object) and owner != object:
		object_refs.append(weakref(object))
		object_detected.emit(object)


func _on_area_exited(area):
	var object = area.get_parent()
	for ref in object_refs:
		if ref.get_ref() == object:
			objet_undetected.emit(object)
			object_refs.erase(ref)
