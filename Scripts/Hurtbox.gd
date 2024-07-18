extends Area2D
class_name Hurtbox

@export var health : Health

func _on_area_entered(hitbox : Hitbox):
	if hitbox.is_custom_knockback_direction:
		health.damage(hitbox.damage, hitbox.knockback, hitbox.custom_knockback_direction)
	else:
		health.damage(hitbox.damage, hitbox.knockback, hitbox.global_position.direction_to(global_position))
