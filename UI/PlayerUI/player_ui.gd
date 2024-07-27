extends Control

func _ready():
	$ColorRect/Icons/coins.text = "[color=#7be4ef]" + str(ScoreManager.coins) + "		/		20[/color]"
	$ColorRect/Icons/deaths.text = "[color=#e9ffff]" + str(ScoreManager.deaths) + "	[/color]"
	$AnimationPlayer.play("UI_Zoom_Out")

func animation_over():
	queue_free()
