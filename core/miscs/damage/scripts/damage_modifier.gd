extends Resource
class_name DamageModifier


func can_damage(_hitbox: HitBox, _source: DamageSource) -> bool:
	return true

func get_damage(_hitbox: HitBox, source: DamageSource) -> int:
	return source.damage
