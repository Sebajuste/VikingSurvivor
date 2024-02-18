# @tool
extends Node3D
class_name DayNightCycle

@export var environment : WorldEnvironment

@export var day_length := 20.0
@export_range(0.0, 1.0) var start_time := 0.3:
	set(value):
		time = start_time
@export var running := true

@export_group("Sky", "sky")
@export var sky_top_color : Gradient
@export var sky_horizon_color : Gradient

@export_group("Sun", "sun")
@export var sun_color: Gradient
@export var sun_intensity: Curve
@onready var sun := $Sun

@export_group("Moon", "moon")
@export var moon_color: Gradient
@export var moon_intensity: Curve
@onready var moon := $Moon

@export_range(0.0, 1.0) var time : float
var time_rate := 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	time_rate = 1.0 / day_length
	time = start_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if running and not Engine.is_editor_hint():
		time = wrap(time + time_rate * delta, 0.0, 1.0)
	
	sun.rotation_degrees.x = time * 360 + 90
	sun.light_color = sun_color.sample(time)
	sun.light_energy = sun_intensity.sample(time)
	
	moon.rotation_degrees.x = time * 360 + 270
	moon.light_color = moon_color.sample(time)
	moon.light_energy = moon_intensity.sample(time)
	
	sun.visible = sun.light_energy > 0.0
	moon.visible = moon.light_energy > 0.0
	
	if environment:
		environment.environment.sky.sky_material.set("sky_top_color", sky_top_color.sample(time))
		environment.environment.sky.sky_material.set("sky_horizon_color", sky_horizon_color.sample(time))
		
		environment.environment.sky.sky_material.set("ground_bottom_color", sky_top_color.sample(time))
		environment.environment.sky.sky_material.set("ground_horizon_color", sky_horizon_color.sample(time))
		
		environment.environment.volumetric_fog_albedo = sky_top_color.sample(time)

