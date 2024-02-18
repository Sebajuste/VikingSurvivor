extends VBoxContainer

@export var require := 0
@export var quantity := 0

@export var item_scene : PackedScene
@export var item_offset := Vector3.ZERO

@onready var item_icon = $ItemIcon
@onready var label = $Label

var icon_updated := false

# Called when the node enters the scene tree for the first time.
func _ready():
	item_icon.item_offset = item_offset
	item_icon.item_scene = item_scene
	update()
	pass # Replace with function body.



func update():
	label.text = "%d / %d" % [quantity, require]
	if not icon_updated:
		item_icon.update()
		icon_updated = true
