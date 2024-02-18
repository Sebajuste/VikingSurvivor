extends Node3D

@onready var weather_control = $WeatherControl

@onready var weather_slider = $GUI/VBoxContainer/WeatherControl/WeatherSlider
@onready var weather_value = $GUI/VBoxContainer/WeatherControl/Value

@onready var temperature_slider = $GUI/VBoxContainer/TemperatureControl/TemperatureSlider
@onready var temperature_value = $GUI/VBoxContainer/TemperatureControl/Value
@onready var character_temperature_value = $GUI/VBoxContainer/CharacterTemperature/Value
@onready var character_health_value = $GUI/VBoxContainer/CharacterHealth/Value

@onready var character = $ActorCharacterPlayer
@onready var character_weather_probe = $ActorCharacterPlayer/WeatherProbe

@onready var resource_log = $ProtonScatterLog

# Called when the node enters the scene tree for the first time.
func _ready():
	
	weather_slider.value = weather_control.weather_offset
	temperature_slider.value = weather_control.temperature_offset
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	weather_value.text = str("%0.2f" % weather_control.weather)
	
	temperature_value.text = str("%0.2f°C" % weather_control.temperature )
	
	character_temperature_value.text = str("%0.2f°C" % character_weather_probe.temperature)
	
	character_health_value.text = str("%d" % character.damage_stats.health)
	
	pass

func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	

func _on_weather_slider_value_changed(value):
	
	weather_control.weather_offset = value
	
	pass # Replace with function body.


func _on_temperature_slider_value_changed(value):
	
	weather_control.temperature_offset = value
	
	pass # Replace with function body.


func _on_reload_resource_timer_timeout():
	
	resource_log.rebuild()
	
	pass # Replace with function body.


func _on_weather_probe_temperature_changed(temperature):
	print("_on_weather_probe_temperature_changed: ", temperature)
	pass # Replace with function body.
