extends Area2D
class_name Spring

@export var SPRING_VELOCITY : float = 2000.0
@export var PERPENDICULAR_DAMPENING : float = 0.2

@export var USE_CUSTOM_VELOCITY : bool = false
@export var CUSTOM_VELOCITY : Vector2 = Vector2(2000, 2000)

@onready var animation : AnimationPlayer = $AnimationPlayer

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@export var sound : AudioStream

func _on_body_entered(p : PlayerCharacter):
	bounce(p)

#region Helper Functions
func get_perpendicular_velocity(p : PlayerCharacter) -> Vector2:
	var rotated_velocity : Vector2 = p.velocity.rotated(-global_rotation)
	return Vector2(rotated_velocity.x, 0.0).rotated(global_rotation) * PERPENDICULAR_DAMPENING

func get_spring_velocity() -> Vector2:
	return Vector2(0, -SPRING_VELOCITY).rotated(global_rotation)

func bounce(p : PlayerCharacter):
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound
	s.volume_db = -8
	get_tree().current_scene.add_child(s)
	
	if USE_CUSTOM_VELOCITY:
		p.set_player_velocity(CUSTOM_VELOCITY + get_perpendicular_velocity(p))
	else:
		p.set_player_velocity(get_spring_velocity() + get_perpendicular_velocity(p))
	
	p.ground_refresh_hooks()
	p.refresh_dash_charges()
	p.end_dash()
	animation.pause()
	animation.play("bounce")
#endregion
