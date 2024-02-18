extends Area3D
class_name HitBox

signal damaged(value)

@export_node_path("DamageStats")
var damage_stats_path

@export_group("Effect", "effect_")
@export var effect_scene : PackedScene
@export var effect_audio : AudioStream

@export var enabled := true:
	set(val):
		enabled = val
		$CollisionShape3D.disabled = not val
		if is_multiplayer_authority():
			_set_enabled.rpc(val)

@export var modifiers : Array[DamageModifier] = []

@onready var damage_stats : DamageStats = get_node_or_null(damage_stats_path)
@onready var audio_hit := $HitEffect





# Called when the node enters the scene tree for the first time.
func _ready():
	
	if effect_audio:
		audio_hit.stream = effect_audio
	
	pass # Replace with function body.


func can_damage(source: DamageSource) -> bool:
	
	for modifier in modifiers:
		var result := modifier.can_damage(self, source)
		if not result:
			return false
	
	return true

@rpc("any_peer", "call_local", "reliable")
func damage_receive(_from, value):
	if is_multiplayer_authority():
		damaged.emit(value)
		if damage_stats:
			damage_stats.take_damage(value)
		
		run_effect()

@rpc("any_peer", "call_remote", "reliable")
func _set_enabled(value):
	enabled = value

func run_effect():
	if effect_scene:
		var effect := effect_scene.instantiate()
		owner.get_parent().add_child(effect)
		effect.global_position = self.global_position
	audio_hit.pitch_scale = 1 + randf_range(-0.2, 0.2)
	audio_hit.playing = true

func _on_area_entered(_area):
	print("HitBox::_on_area_entered")
	pass # Replace with function body.

