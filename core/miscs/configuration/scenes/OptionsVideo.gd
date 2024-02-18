extends VBoxContainer

@onready var resolution_select = $HBoxContainer/ResolutionList

@onready var fullscreen_checkbox = $HBoxContainer2/Fullscreen
@onready var vsync_checkbox = $HBoxContainer3/Vsync
@onready var antialiasing_checkbox = $HBoxContainer4/Antialiasing

@onready var trees_details_select = $TreeDetails/TreesDetailsList
@onready var rain_details_select = $RainDetails/RainDetailsList
@onready var clouds_quality_select = $CloudsQuality/CloudsQualityList
@onready var god_rays_checkbox = $GodRays/GodRaysCheckbox


const OPTIONS_LEVELS_4 := {
	0: "ultra",
	1: "high",
	2: "medium",
	3: "low",
}

const CLOUDS_QUALITY := {
	"ultra": 100,
	"high": 60,
	"medium": 25,
	"low": 10,
}


var display = {"h": 0, "w":0}
var fullscreen
var antialiasing = true
var vsync = true

var trees_detail_level : String
var rain_detail_level : String
var clouds_quality : int
var god_rays := false

func reload():
	
	# Load configuration values
	display.h = Configuration.Settings.Display.HEIGHT
	display.w = Configuration.Settings.Display.WIDTH
	fullscreen = Configuration.Settings.Display.FullScreen
	vsync = Configuration.Settings.Display.Vsync
	antialiasing = Configuration.Settings.Display.Antialiasing
	
	trees_detail_level = Configuration.Settings.Display.Trees
	rain_detail_level = Configuration.Settings.Display.RainDetails
	clouds_quality = Configuration.Settings.Display.CloudsQuality
	god_rays = Configuration.Settings.Display.GodRays
	
	# Update UI selectors
	for index in resolution_select.get_item_count():
		var text = resolution_select.get_item_text(index)
		var res = text.split("x")
		
		if res[1] == str(display.h) && res[0] == str(display.w):
			resolution_select.select(index)
	
	fullscreen_checkbox.button_pressed = fullscreen
	vsync_checkbox.button_pressed = vsync
	antialiasing_checkbox.button_pressed = antialiasing
	
	for index in range(OPTIONS_LEVELS_4.size()):
		if OPTIONS_LEVELS_4[index] == trees_detail_level:
			trees_details_select.select(index)
			break
	
	for index in range(OPTIONS_LEVELS_4.size()):
		if OPTIONS_LEVELS_4[index] == rain_detail_level:
			rain_details_select.select(index)
			break
	
	for index in range(OPTIONS_LEVELS_4.size()):
		if CLOUDS_QUALITY[OPTIONS_LEVELS_4[index]] == clouds_quality:
			clouds_quality_select.select(index)
			break
	
	god_rays_checkbox.button_pressed = god_rays
	


func apply():
	
	Configuration.Settings.Display.HEIGHT = display.h
	Configuration.Settings.Display.WIDTH = display.w
	Configuration.Settings.Display.FullScreen = fullscreen
	Configuration.Settings.Display.Vsync = vsync
	Configuration.Settings.Display.Antialiasing = antialiasing
	
	Configuration.Settings.Display.Trees = trees_detail_level
	Configuration.Settings.Display.Rain = rain_detail_level
	Configuration.Settings.Display.CloudsQuality = clouds_quality
	Configuration.Settings.Display.GodRays = god_rays
	
	Configuration.apply_settings()


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#resolution_select.add_item("640x480")
	#resolution_select.add_item("800x600")
	resolution_select.add_item("1280x720")
	resolution_select.add_item("1600x900")
	resolution_select.add_item("1920x1080")
	
	reload()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ResolutionList_item_selected(ID):
	var res = resolution_select.get_item_text(ID).split("x")
	display.w = res[0]
	display.h = res[1]
	apply()


func _on_Fullscreen_toggled(button_pressed):
	
	fullscreen = button_pressed
	apply()


func _on_Vsync_toggled(button_pressed):
	
	vsync = button_pressed
	apply()


func _on_Antialiasing_toggled(button_pressed):
	
	antialiasing = button_pressed
	apply()


func _on_TreesDetailsList_item_selected(index):
	trees_detail_level = OPTIONS_LEVELS_4[index]
	apply()


func _on_RainDetailsList_item_selected(index):
	rain_detail_level = OPTIONS_LEVELS_4[index]
	apply()


func _on_CloudsQualityList_item_selected(index):
	var quality : String = OPTIONS_LEVELS_4[index]
	clouds_quality = CLOUDS_QUALITY[quality]
	apply()


func _on_GodRays_toggled(button_pressed):
	god_rays = button_pressed
	apply()
