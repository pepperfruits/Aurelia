extends Area2D
class_name Spring

@export var SPRING_VELOCITY : float = 2000.0
@export var HORIZONTAL_BONUS : float = 3.0
@export var PERPENDICULAR_DAMPENING : float = 0.2

func _on_body_entered(p : PlayerCharacter):
	bounce(p)

#region Helper Functions
func get_perpendicular_velocity(p : PlayerCharacter) -> Vector2:
	var rotated_velocity : Vector2 = p.velocity.rotated(-global_rotation)
	return Vector2(rotated_velocity.x, 0.0).rotated(global_rotation) * PERPENDICULAR_DAMPENING

func get_spring_velocity() -> Vector2:
	return Vector2(0, -SPRING_VELOCITY).rotated(global_rotation)

func get_horizontal_bonus() -> Vector2:
	return Vector2(HORIZONTAL_BONUS, 1.0)

func bounce(p : PlayerCharacter):
	p.set_player_velocity(get_spring_velocity() + get_perpendicular_velocity(p) * get_horizontal_bonus())
	p.refresh_dash_charges()
	p.end_dash()
#endregion
