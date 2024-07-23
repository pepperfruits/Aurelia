extends Area2D
class_name LevelChangeArea

@export var scene : PackedScene
@export var coinArea : CoinCollectionArea

@onready var timer : Timer = $LevelChangeTimer

func _on_body_entered(body : PlayerCharacter):
	timer.start()
	body.set_camera_transition(true)

func _on_level_change_timer_timeout():
	ScoreManager.coins += coinArea.get_overlapping_areas().size()
	get_tree().change_scene_to_packed(scene)
