extends StaticBody2D
class_name Platform

@export var HOLD_TO_FALL_VELOCITY : float = 200.0

@onready var p : PlayerCharacter = $"..".p
@onready var CollisionShape : CollisionShape2D = $PlatformCollisionShape
@onready var PlayerDetection : Area2D = $PlayerDetectionArea

func _process(_delta):
	var inp : PlayerInputHandler = p.InputHandler
	CollisionShape.disabled = inp.is_down_inputted() or (inp.get_vertical_input() < 0 and p.velocity.y < HOLD_TO_FALL_VELOCITY) or p.velocity.y < 0 or not PlayerDetection.get_overlapping_bodies().is_empty()
