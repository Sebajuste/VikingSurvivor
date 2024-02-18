extends Resource
class_name GameItem

@export var name := ""
@export var object_type := ""
@export var max_stack := 1:
	set(value):
		max_stack = max(value, 1)
@export var quantity := 1:
	set(value):
		quantity = clamp(value, 1, max_stack)
@export var properties : Dictionary = {}

@export var model : PackedScene

func is_stackable() -> bool:
	
	return max_stack > 1
	
