extends Node

@export var temperature_breath_threshold := -5.0
@export var temperature_damage := 1
@export var temperature_damage_threshold := -10.0

@onready var character : ActorCharacter = owner
@onready var breath = owner.get_node("Breath")
@onready var timer = $ColdDamageTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var temperature := character.weather_probe.temperature
	
	if temperature <= temperature_breath_threshold:
		breath.emitting = true
	elif temperature > temperature_breath_threshold:
		breath.emitting = false
	
	if temperature <= temperature_damage_threshold and timer.is_stopped():
		timer.start()
	elif temperature > temperature_damage_threshold and not timer.is_stopped():
		timer.stop()
	



func _on_timer_timeout():
	
	character.damage_stats.take_damage(temperature_damage)
	
	pass # Replace with function body.


func _on_damage_stats_health_depleted():
	set_process(false)
	timer.stop()
	breath.emitting = false
