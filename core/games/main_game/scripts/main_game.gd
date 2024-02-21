extends Node3D

# const MENU_SCENE = preload("res://core/games/main_menu/scenes/main_menu.tscn")

@onready var player : ActorCharacter = $Player
@onready var cold_damage = $Player/ColdDamage

@onready var ice_screen = $IceScreen
@onready var gui_inventory = $GUI/GUIInventoryList
@onready var gui_endgame = $GUI/EndGame
@onready var gui_menu = $GUI/Menu
@onready var gui_options = $GUI/OptionsWindow

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gui_inventory.inventory = player.inventory
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var half_health = player.damage_stats.max_health * 0.75
	if player.damage_stats.health <= half_health:
		ice_screen.intensity = (1.0 - (player.damage_stats.health/half_health)) * 2.0
	
	if player.weather_probe.temperature <= -10 and player.damage_stats.is_alive():
		cold_damage.emitting = true
	else:
		cold_damage.emitting = false


func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		if not gui_endgame.visible:
			gui_menu.visible = not gui_menu.visible
			if gui_menu.visible:
				gui_menu.get_node("VBoxContainer/Control/VBoxContainer/Close").grab_focus()
		else:
			gui_menu.visible = false
	

func _on_player_damaged(_damage, _health):
	if cold_damage:
		cold_damage.emitting = true
		await get_tree().create_timer(0.9).timeout 
		cold_damage.emitting = false
	pass # Replace with function body.

func _on_work_shop_built():
	
	LevelLoader.thread_load("res://core/games/credits/scenes/credits.tscn")
	
	pass # Replace with function body.

func _on_player_died():
	gui_endgame.visible = true
	gui_menu.visible = false
	gui_options.visible = false
	pass # Replace with function body.

func _on_close_pressed():
	gui_menu.visible = false
	gui_options.visible = false
	pass # Replace with function body.


func _on_options_pressed():
	gui_menu.visible = false
	gui_options.visible = true
	pass # Replace with function body.

func _on_restart_button_pressed():
	LevelLoader.thread_load("res://core/games/main_game/scenes/main_game.tscn")
	gui_endgame.visible = false
	gui_menu.visible = false
	pass # Replace with function body.

func _on_back_menu_pressed():
	LevelLoader.thread_load("res://core/games/main_menu/scenes/main_menu.tscn")
	gui_endgame.visible = false
	gui_menu.visible = false
	pass # Replace with function body.

func _on_quitter_button_pressed():
	get_tree().quit()
	# LevelLoader.thread_load("res://core/games/main_menu/scenes/main_menu.tscn")
	# gui_endgame.visible = false
	pass # Replace with function body.


