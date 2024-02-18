extends HBoxContainer


@onready var item_icon = $ItemIcon
@onready var value = $Value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_item(item: GameItem):
	if item:
		if item.model:
			item_icon.item_scene = item.model
			item_icon.update()
		value.text = str(item.quantity)
