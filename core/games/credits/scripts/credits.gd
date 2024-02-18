extends Node3D

@onready var cutscene = $Cutscene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$DayNightCycle.time = 0.2
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass


func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		change_level()
	

"""
func _on_start_timer_timeout():
	gui_animation.play("fade_out_long")
	pass # Replace with function body.
"""

func change_level():
	LevelLoader.thread_load("res://core/games/main_menu/scenes/main_menu.tscn")
	pass

func _on_quit_pressed():
	
	get_tree().quit()
	
	pass # Replace with function body.


func _on_play_pressed():
	
	cutscene.play("start")
	
	pass # Replace with function body.


func _on_actor_character_player_damaged(_damage, _health):
	pass # Replace with function body.
