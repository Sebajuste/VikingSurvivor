extends VBoxContainer


@onready var general_slider = $Master/Slider
@onready var music_slider = $Music/Slider
@onready var effects_slider = $SoundEffects/Slider
@onready var mute_checkbox = $Mute/Checkbox

var general := 100
var music := 100
var sound_effects := 100
var mute := false

func reload():
	
	general = Configuration.Settings.Audio.MASTER
	music = Configuration.Settings.Audio.MUSIC
	sound_effects = Configuration.Settings.Audio.EFFECTS
	
	mute = Configuration.Settings.Audio.MUTE
	
	
	general_slider.value = ( (general + 20) * 100) / 25.0
	music_slider.value = ( (music + 20) * 100) / 25.0
	effects_slider.value = ( (sound_effects + 20) * 100) / 25.0
	
	mute_checkbox.button_pressed  = mute
	


func apply():
	
	Configuration.Settings.Audio.MASTER = general
	Configuration.Settings.Audio.MUSIC = music
	Configuration.Settings.Audio.EFFECTS = sound_effects
	
	Configuration.Settings.Audio.MUTE = mute
	
	Configuration.apply_settings()


# Called when the node enters the scene tree for the first time.
func _ready():
	
	reload()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_General_value_changed(value):
	
	general = ( (value * 25) / 100 ) - 20
	apply()

func _on_Music_value_changed(value):
	
	music = ( (value * 25) / 100 ) - 20
	apply()

func _on_Effects_value_changed(value):
	
	sound_effects = ( (value * 25) / 100 ) - 20
	apply()

func _on_Mute_toggled(button_pressed):
	print("_on_Mute_toggled ", button_pressed)
	mute = button_pressed
	apply()
