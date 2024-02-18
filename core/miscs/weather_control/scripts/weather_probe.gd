extends Node3D
class_name WeatherProbe


@export var weather : Weather

var _weather_modifiers : Array[WeatherModifier] = []

var temperature := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not weather:
		var _weathers = get_tree().get_nodes_in_group("weather_controller")
		if _weathers and _weathers.size() > 0:
			weather = _weathers[0]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var old_temperature := temperature
	
	var temperature_modifier := 0.0
	for modifier in _weather_modifiers:
		if modifier.enabled:
			#temperature_modifier = maxf(temperature_modifier, modifier.get_temperature_modifier(global_position))
			temperature_modifier += modifier.get_temperature_modifier(global_position)
	
	if weather:
		temperature = weather.temperature + clamp(temperature_modifier, -15, 15)
	
	
	pass


func _on_area_3d_area_entered(area : Area3D):
	_weather_modifiers.push_back(area.get_parent())
	pass # Replace with function body.


func _on_area_3d_area_exited(area : Area3D):
	_weather_modifiers.erase(area.get_parent())
	pass # Replace with function body.
