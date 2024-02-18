extends Node3D


@onready var player = $ActorCharacterPlayer

@onready var gui_inventory := $CanvasLayer/GUI/InventoryList

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gui_inventory.inventory = player.inventory
	
	# $AudioStreamPlayer.playing = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
