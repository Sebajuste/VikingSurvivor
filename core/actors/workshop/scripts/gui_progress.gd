extends Node3D

@export var radius := 50
@export var width := 5
@export var color := Color.SKY_BLUE

@onready var gui_loading := $Texture/SubViewport/GUILoading

var percent := 0.0 : set = _set_percent

func _set_percent(value: float):
	percent = value
	gui_loading.queue_redraw()
