extends Control

@export var item_scene : PackedScene
@export var item_offset := Vector3.ZERO

@onready var offset = $IconWiewver/Offset
@onready var skin = $IconWiewver/Offset/Skin

# Called when the node enters the scene tree for the first time.
func _ready():
	
	offset.position = item_offset
	
	update()
	
	pass # Replace with function body.

func update():
	for child in skin.get_children():
		child.queue_free()
	if item_scene:
		var item = item_scene.instantiate()
		skin.add_child(item)

