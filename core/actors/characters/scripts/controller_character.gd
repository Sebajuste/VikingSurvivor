extends Node
class_name CharacterController

@export var character : ActorCharacter

@export var enabled := true

@onready var character_ref : WeakRef = weakref(character) if character else weakref(null)


func _ready():
	if character_ref.get_ref():
		_update_character(character_ref.get_ref())


func set_character(value):
	character_ref = weakref(value)

func get_character() -> CharacterBody3D:
	
	return character_ref.get_ref()

func _update_character(value):
	value.control_fsm.transition_to("Player")
	pass
