extends Node3D

@export var first_level_path : String

@onready var cutscene = $Cutscene
#@onready var gui_animation = $CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$DayNightCycle.time = 0.8
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass

"""
func _on_start_timer_timeout():
	gui_animation.play("fade_out_long")
	pass # Replace with function body.
"""

func change_level():
	LevelLoader.thread_load(first_level_path)
	pass

func _on_quit_pressed():
	
	get_tree().quit()
	
	pass # Replace with function body.


func _on_play_pressed():
	
	cutscene.play("start")
	
	pass # Replace with function body.


func _on_actor_character_player_damaged(_damage, _health):
	pass # Replace with function body.