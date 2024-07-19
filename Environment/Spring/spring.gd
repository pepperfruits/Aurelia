extends Area2D

@export var SPRING_VELOCITY : float = 2000.0
@export var HORIZONTAL_BONUS : float = 3.0
@export var PERPENDICULAR_DAMPENING : float = 0.2

func _on_body_entered(body : PlayerCharacter):
	var rotated_velocity : Vector2 = body.velocity.rotated(-global_rotation)
	var perpendicular_velocity : Vector2 = Vector2(rotated_velocity.x, 0.0).rotated(global_rotation) * PERPENDICULAR_DAMPENING
	body.velocity = Vector2(0, -SPRING_VELOCITY).rotated(global_rotation) + perpendicular_velocity * Vector2(HORIZONTAL_BONUS, 1.0)
	body.Movement.momentum = body.velocity.x
	body.Movement.refresh_dash_charges()
	body.Movement.dashing = false

