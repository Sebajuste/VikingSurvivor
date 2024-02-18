extends Node3D
class_name WeatherModifier

#@export var weather : Weather
@export var shape : SphereShape3D
@export var enabled := true
@export var temperature := 0.0
@export var temperature_distance : Curve


@onready var collision_shape = $Area3D/CollisionShape3D



# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape.shape = shape
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_temperature_modifier(pos : Vector3) -> float:
	if not enabled:
		return 0.0
	var distance := global_position.distance_to(pos)
	if temperature_distance:
		return temperature_distance.sample(distance / shape.radius) * temperature
	else:
		return (1.0 - distance / shape.radius) * temperature
	
