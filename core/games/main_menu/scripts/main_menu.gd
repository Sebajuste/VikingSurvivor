extends Node3D

@export var first_level_path : String

@onready var options = $OptionsWindow
@onready var cutscene = $Cutscene
#@onready var gui_animation = $CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$DayNightCycle.time = 0.8
	
	pass # Replace with function body.


func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel") and cutscene.is_playing() and cutscene.current_animation == "start":
		# Skip cutscene
		change_level()

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


func _on_options_pressed():
	options.visible = true
	pass # Replace with function body.


func _on_options_window_close_requested():
	options.visible = false
	pass # Replace with function body.
