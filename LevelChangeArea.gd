extends Area2D

@export var scene : PackedScene

@onready var timer : Timer = $LevelChangeTimer

func _on_body_entered(body : PlayerCharacter):
	timer.start()
	body.set_camera_transition(true)

func _on_level_change_timer_timeout():
	get_tree().change_scene_to_packed(scene)
