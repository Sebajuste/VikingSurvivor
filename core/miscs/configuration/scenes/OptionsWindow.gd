extends Window


@onready var sound_tab := $MarginContainer/VBoxContainer/TabContainer/Sound
@onready var display_tab := $MarginContainer/VBoxContainer/TabContainer/Display
#@onready var game_tab := $MarginContainer/VBoxContainer/TabContainer/Game

@onready var first_focus = $MarginContainer/VBoxContainer/Footer/HBoxContainer3/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if visible:
		first_focus.grab_focus()
	
	var _r := Configuration.configuration_changed.connect(_on_configuration_changed)
	
	update_title_translation()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_title_translation():
	
	sound_tab.name = tr("title_sound")
	display_tab.name = tr("title_display")
	#game_tab.name = tr("title_game")
	


func _on_configuration_changed(_config):
	
	update_title_translation()
	



func _on_about_to_show():
	
	update_title_translation()
	


func _on_RestoreDefaultButton_pressed():
	
	pass # Replace with function body.


func _on_SaveButton_pressed():
	
	Configuration.save_settings()
	


func _on_CloseButton_pressed():
	
	hide()
	


func _on_visibility_changed():
	if visible:
		first_focus.grab_focus()
	pass # Replace with function body.
