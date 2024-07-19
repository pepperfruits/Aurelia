extends Node
class_name Health

@export var entity : Node2D
@export var hurtbox : Area2D

@export var max_health : int = 3
@export var health : int = 3
@export var invincibility_window : float = 1.0

func death() -> void:
	entity.queue_free()

func damage(amount : int, knockback : float, knockback_vector : Vector2) -> void:
	health -= amount
	if knockback:
		apply_knockback(knockback, knockback_vector)
	if (health <= 0):
		death()

func apply_knockback(knockback : float, knockback_vector : Vector2) -> void:
	entity.velocity = knockback_vector.normalized() * knockback
