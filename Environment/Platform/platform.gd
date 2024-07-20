extends StaticBody2D
class_name Platform

@export var HOLD_TO_FALL_VELOCITY : float = 200.0

var p : PlayerCharacter = null
@onready var CollisionShape : CollisionShape2D = $PlatformCollisionShape
@onready var DisablePlatformDetection : Area2D = $DisablePlatformDetection
@onready var OnPlatformDetection : Area2D = $OnPlatformDetection

func _process(_delta):
	if p:
		CollisionShape.disabled = is_disabled()

func is_disabled():
	var down_pressed : bool = p.InputHandler.is_down_inputted()
	var down_held : bool = (p.InputHandler.get_vertical_input() < 0 and p.velocity.y < HOLD_TO_FALL_VELOCITY)
	var going_up : bool = p.velocity.y < 0
	var inside_platform : bool = not DisablePlatformDetection.get_overlapping_bodies().is_empty()
	
	return down_pressed or down_held or going_up or inside_platform

func _on_on_platform_detection_body_entered(body : PlayerCharacter):
	p = body

func _on_on_platform_detection_body_exited(_body):
	p = null
	CollisionShape.disabled = true
