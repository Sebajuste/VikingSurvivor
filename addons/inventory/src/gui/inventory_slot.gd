extends Panel
class_name GUIInventorySlot


@onready var texture_rect := $MarginContainer/TextureRect
@onready var quantity := $Quantity


var item : GameItem:
	set(value):
		if item != value:
			item = value
			update_texture()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_texture():
	
	if not item:
		return
	
	if item.object_type == "coins":
		texture_rect.texture = load("res://assets/2d/textures/coins.png")
	elif item.object_type == "cannon":
		texture_rect.texture = load("res://assets/2d/textures/cannon.png")
	else:
		texture_rect.texture = null
	
	if item.quantity > 1:
		quantity.visible = true
		quantity.text = str(item.quantity)
	else:
		quantity.visible = false
