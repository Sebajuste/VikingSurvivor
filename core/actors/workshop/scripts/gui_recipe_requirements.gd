extends Node3D
class_name GUIRecipeRequirements

const ITEM_SCENE = preload("res://core/actors/workshop/gui/gui_item_requirement.tscn")

@export var craft : CraftAbstract

@onready var item_list = $Texture/SubViewport/Control/Content/ItemList

@onready var icon_keyboard = $Texture/SubViewport/Control/Content/IconKeyboard
@onready var icon_xboxone = $Texture/SubViewport/Control/Content/IconXboxOne


var activable := false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Controller.controller_changed.connect(_on_controller_changed)
	
	_on_controller_changed(Controller.type)
	
	pass # Replace with function body.


func update():
	
	_on_controller_changed(Controller.type)
	
	if not craft:
		return
	
	for item in item_list.get_children():
		item.queue_free()
	
	for input in craft.build_recipe.inputs:
		
		var require = input.quantity
		var quantity := 0
		
		var slot_id := craft.inventory.find_item(input.item)
		if slot_id != -1:
			var item = craft.inventory.get_item(slot_id)
			quantity = item.quantity
		
		var gui_item = ITEM_SCENE.instantiate()
		gui_item.item_scene = input.item.model
		gui_item.require = require
		gui_item.quantity = quantity
		
		item_list.add_child(gui_item)
		
	
	pass

func enable():
	$AnimationPlayer.play("fade_out")
	pass

func disable():
	$AnimationPlayer.play("fade_in")

func _on_visibility_changed():
	
	if visible:
		$AnimationPlayer.play("fade_out")
	else:
		$AnimationPlayer.play("fade_in")

func _on_controller_changed(type):
	
	icon_keyboard.visible = false
	icon_xboxone.visible = false
	
	if not activable:
		return
	
	match type:
		Controller.Type.MOUSE_KEYBOARD:
			icon_keyboard.visible = true
		Controller.Type.GAMEPAD:
			icon_xboxone.visible = true
		_:
			pass
	
	pass
