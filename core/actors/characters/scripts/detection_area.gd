extends Area3D
class_name ActorDetection

signal body_detected(object)
signal body_undetected(object)

const DEFAULT_RADIUS := 10.0

@export var radius := DEFAULT_RADIUS

@onready var collision_shape : CollisionShape3D = $CollisionShape3D

var body_refs : Array[WeakRef] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_radius(radius)
	
	pass # Replace with function body.

func set_radius(value: float):
	if value != DEFAULT_RADIUS or radius != DEFAULT_RADIUS:
		collision_shape.shape = collision_shape.shape.duplicate()
		collision_shape.shape.radius = value
	radius = value

func clean():
	for ref in body_refs:
		if ref.get_ref() == null:
			body_refs.erase(ref)

func get_bodies() -> Array[Node3D]:
	clean()
	var result : Array[Node3D] = []
	for ref in body_refs:
		result.append(ref.get_ref())
	return result

func has_body(body):
	for ref in body_refs:
		if ref.get_ref() == body:
			return true

func _on_body_entered(body):
	if not has_body(body) and owner != body:
		body_refs.append(weakref(body))
		body_detected.emit(body)


func _on_body_exited(body):
	for ref in body_refs:
		if ref.get_ref() == body:
			body_undetected.emit(body)
			body_refs.erase(ref)
	
