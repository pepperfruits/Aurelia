extends Area2D
class_name AirDraft

@export var MAX_SPEED : float = 500.0
@export var FORCE : float = 2550.0
@export var STOPPING_BONUS : float = 2.0

# NOTICE dont try to make this rotated anywhere but up for now

func _process(delta):
	if not get_overlapping_bodies().is_empty():
		var p : PlayerCharacter = get_overlapping_bodies().front()
		p.refresh_dash_charges()
		if p.velocity.y > -MAX_SPEED:
			apply_force(delta, p)

func apply_force(delta : float, p : PlayerCharacter) -> void:
	if p.velocity.y > 0:
		p.set_player_velocity(Vector2(p.velocity.x, p.velocity.y) + Vector2(0, -FORCE) * delta * STOPPING_BONUS * max(1,(abs(p.velocity.y) / MAX_SPEED)))
	else:
		p.set_player_velocity(Vector2(p.velocity.x, p.velocity.y) + Vector2(0, -FORCE) * delta)
