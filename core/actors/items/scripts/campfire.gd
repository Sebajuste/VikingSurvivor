extends Node3D

@onready var weather_modifier = $Effects/WeatherModifier
@onready var fire_base = $Effects/FireBase
@onready var fire_particles = $Effects/FireParticle
@onready var fire_floating = $Effects/Floating
@onready var smoke = $Effects/Smoke
@onready var light = $Effects/Light
@onready var audio = $Effects/AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	disable()
	pass # Replace with function body.


func is_enabled():
	return light.enabled

func toggle():
	if is_enabled():
		disable()
	else:
		enable()

func enable():
	weather_modifier.enabled = true
	fire_base.emitting = true
	fire_particles.emitting = true
	fire_floating.emitting = true
	smoke.emitting = true
	light.visible = true
	audio.playing = true

func disable():
	weather_modifier.enabled = false
	fire_base.emitting = false
	fire_particles.emitting = false
	fire_floating.emitting = false
	smoke.emitting = false
	light.visible = false
	audio.playing = false
