extends Area3D
class_name DamageSource

@export var damage := 1

var hits := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#monitoring = is_multiplayer_authority()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_entered(hitbox : HitBox):
	
	if owner.is_ancestor_of(hitbox) or hitbox.owner.is_ancestor_of(self):
		return
	
	if is_multiplayer_authority() and hitbox.enabled and hitbox.can_damage(self):
		
		if not hits.has(hitbox) or hits[hitbox] == false:
			hits[hitbox] = true
			hitbox.damage_receive.rpc(self, damage)
			hitbox.run_effect()

func _on_area_exited(hitbox : HitBox):
	hits.erase(hitbox)
	pass # Replace with function body.
