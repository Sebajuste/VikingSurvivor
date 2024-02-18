class_name DamageStats
extends Node

signal health_depleted()
signal damaged(damage, old_health, new_health)

@export
var max_health := 100

var health := max_health:
	set(val):
		var old_health = health
		health = clamp(val, 0, max_health)
		if old_health > health:
			damaged.emit(old_health-health, old_health, health)
			if health == 0:
				health_depleted.emit()

func _ready():
	health = max_health

func is_alive() -> bool:
	return health > 0


func take_damage(value : int):
	#var old_health = health
	health = max(0, health - value)
	"""
	damaged.emit(value, old_health, health)
	if health == 0:
		health_depleted.emit()
	"""


func heal(value : int):
	if is_alive():
		health = min(health + value, max_health)
	
