extends CharacterBody3D
class_name ActorCharacter

signal damaged(damage, health)
signal died

@export_group("Move")
@export var move_speed_walk := 1
@export var move_speed_run := 2.5


@onready var skin : CharacterSkin = $Skin
@onready var locomotion_fsm : StateMachine = $LocomotionSM
@onready var locomotion : Locomotion = $LocomotionSM/Locomotion

@onready var damage_stats : DamageStats = $DamageStats

@onready var hitbox : HitBox = $HitBox

@onready var detection : ActorDetection = $DetectionArea
@onready var object_detection := $UsableDetection

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D

@onready var control_fsm : StateMachine = $ControlSM

@onready var navigation : NavigationAgent3D = $NavigationAgent3D

@onready var inventory : Inventory = $Inventory

@onready var walk_sound := $WalkSound

@onready var weather_probe : WeatherProbe = $WeatherProbe

## If the character in into combat
var combat_mode := false


func _ready():
	
	locomotion.walk_speed = move_speed_walk
	locomotion.max_speed = move_speed_run
	
	pass



func jump():
	if is_multiplayer_authority() and damage_stats.is_alive():
		var action = get_node_or_null("Actions/JumpAction")
		action.do.rpc()

func attack_primary():
	if is_multiplayer_authority() and damage_stats.is_alive():
		var action = get_node_or_null("Actions/SwordAction")
		action.do.rpc()

func toogle_weapon_draw():
	if is_multiplayer_authority() and damage_stats.is_alive():
		var action = get_node_or_null("Actions/SwordAction")
		action.toggle_draw.rpc()

func weapon_draw():
	var action = get_node_or_null("Actions/SwordAction")
	action.draw.rpc()
	pass

func weapon_sheath():
	var action = get_node_or_null("Actions/SwordAction")
	action.sheath.rpc()
	pass

func block(state: bool):
	if is_multiplayer_authority() and damage_stats.is_alive() and combat_mode:
		var action = get_node_or_null("Actions/ShieldAction")
		if state != action.blocking:
			action.do.rpc({"block": state})


func _on_renamed():
	$Name.text = name
	pass # Replace with function body.


func _on_damage_stats_health_depleted():
	locomotion_fsm.transition_to("Locomotion/Death")
	collision_layer = 0x00
	hitbox.enabled = false
	died.emit()
	pass # Replace with function body.



func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	pass # Replace with function body.


func _on_damage_stats_damaged(damage, _old_health, new_health):
	damaged.emit(damage, new_health)
	pass # Replace with function body.
