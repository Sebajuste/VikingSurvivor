extends Node
class_name Weather

@export var environement : WorldEnvironment
@export var daynight_cycle : DayNightCycle
@export var rain_effect : PackedScene
@export var snow_effect : PackedScene
@export var enabled := true

@export_group("Temperature", "temperature")
@export var temperature_noise : FastNoiseLite
@export var temperature_curve : Curve
@export var temperature_day_nighy_curve : Curve
@export_range(-1.0, 1.0) var temperature_offset := 0.0

@export_group("Weather", "weather")
@export var weather_noise : FastNoiseLite
@export var weather_curve : Curve
@export var weather_fog_max_density := 0.10
@export_range(-1.0, 1.0) var weather_offset := 0.0

const WEATHER_RAIN_THRESHOLD = 0.5
const TEMPERATURE_SNOW_THRESHOLD := 1.0

var temperature := 0.0
@export_range(0.0, 1.0) var temperature_index := 0.5

var weather := 0.0
@export_range(0.0, 1.0) var weather_index := 0.5

var _run := true
var _cursor := 0.0

var _rain_scene
var _snow_scene

var rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng.randomize()
	temperature_noise.seed = rng.randi()
	weather_noise.seed = rng.randi()
	
	process_values()
	
	var probes = get_tree().get_nodes_in_group("weather_probe")
	for probe in probes:
		probe.weather = self
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if _run:
		_cursor += delta
	
	process_values()
	update_effetcts()
	
	pass

func _physics_process(_delta):
	
	var camera = get_viewport().get_camera_3d()
	
	if _rain_scene:
		_rain_scene.global_position = camera.global_position
	
	if _snow_scene:
		_snow_scene.global_position = camera.global_position
	
	pass

func process_values():
	var temperature_daynight = 0.0
	
	if enabled:
		
		if daynight_cycle and temperature_day_nighy_curve:
			temperature_daynight = temperature_day_nighy_curve.sample(daynight_cycle.time)
			pass
		
		temperature_index = clamp( temperature_offset + (temperature_noise.get_noise_1d(_cursor) + 1.0) / 2.0, 0.0, 1.0)
		weather_index = clamp( weather_offset + (weather_noise.get_noise_1d(_cursor) + 1.0) / 2.0, 0.0, 1.0)
	
	
	temperature = clamp(temperature_curve.sample(temperature_index) + temperature_daynight, -15, 25)
	
	weather = weather_curve.sample(weather_index)
	
	# print("index: %0.02f, base temp: %0.02f, day temp: %0.02f, final: %0.02f -- weather_index: %0.02f, weather: %0.02f" % [temperature_index, temperature_curve.sample(temperature_index), temperature_daynight, temperature, weather_index, weather])
	
	

func update_effetcts():
	environement.environment.volumetric_fog_density = weather * weather_fog_max_density
	
	if weather > WEATHER_RAIN_THRESHOLD or temperature < -5.0:
		
		if not _rain_scene and temperature >= 0.0:
			_rain_scene = rain_effect.instantiate()
			get_parent().add_child(_rain_scene)
		
		if not _snow_scene:
			_snow_scene = snow_effect.instantiate()
			get_parent().add_child(_snow_scene)
		
		if _rain_scene and temperature < 0.0:
			_rain_scene.queue_free()
			_rain_scene = null
		
		var weather_offset_delta := 1.0 - WEATHER_RAIN_THRESHOLD
		
		var local_weather_offset = (weather - WEATHER_RAIN_THRESHOLD) / weather_offset_delta
		
		var rain_offset = local_weather_offset * (minf(TEMPERATURE_SNOW_THRESHOLD, maxf(0.0, temperature) ) / TEMPERATURE_SNOW_THRESHOLD)
		var snow_offset = local_weather_offset * (TEMPERATURE_SNOW_THRESHOLD - minf(TEMPERATURE_SNOW_THRESHOLD, maxf(0.0, temperature) ) / TEMPERATURE_SNOW_THRESHOLD)
		
		if _rain_scene:
			_rain_scene.process_material.color_initial_ramp.gradient.offsets[0] = rain_offset
			_rain_scene.process_material.color_initial_ramp.gradient.offsets[1] = rain_offset + 0.01
		
		if _snow_scene:
			_snow_scene.process_material.color_initial_ramp.gradient.offsets[0] = snow_offset
			_snow_scene.process_material.color_initial_ramp.gradient.offsets[1] = snow_offset + 0.01
		
	else:
		if _rain_scene:
			_rain_scene.queue_free()
			_rain_scene = null
		if _snow_scene:
			_snow_scene.queue_free()
			_snow_scene = null

func pause():
	_run = false

func start():
	_run = true
