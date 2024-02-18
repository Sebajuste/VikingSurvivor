extends Control


@onready var gui_progress = owner

func _ready():
	rotation = -PI/2

func _draw():
	
	draw_arc(Vector2.ZERO, gui_progress.radius, 0, (gui_progress.percent/100) * PI*2, 50, gui_progress.color, gui_progress.width)
	
