extends Area2D
class_name AirDraft

@export var MAX_SPEED : float = 500.0
@export var FORCE : float = 2550.0
@export var STOPPING_BONUS : float = 2.0

var Player : PlayerCharacter = null

func _process(delta):
	if Player:
		Player.movement.refresh_dash_charges()
		if -Player.velocity.rotated(-global_rotation).y < MAX_SPEED:
			if Player.velocity.rotated(-global_rotation).y > 0:
				Player.velocity = Vector2(Player.velocity.rotated(-global_rotation).x, Player.velocity.rotated(-global_rotation).y) + Vector2(0, -FORCE).rotated(global_rotation) * delta * STOPPING_BONUS * max(1,(abs(Player.velocity.rotated(-global_rotation).y) / MAX_SPEED))
			else:
				Player.velocity = Vector2(Player.velocity.rotated(-global_rotation).x, Player.velocity.rotated(-global_rotation).y) + Vector2(0, -FORCE).rotated(global_rotation) * delta
			Player.movement.momentum = Player.velocity.x


func _on_body_entered(body):
	Player = body


func _on_body_exited(_body):
	Player = null
