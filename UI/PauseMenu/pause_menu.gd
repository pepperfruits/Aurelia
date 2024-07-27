extends Control
class_name PauseMenu

func pause():
	show()
	get_tree().paused = true
	$Icons/coins.text = "[color=#7be4ef]" + str(ScoreManager.coins) + "		/		20[/color]"
	$Icons/deaths.text = "[color=#2a2834]" + str(ScoreManager.deaths) + "	[/color]"

func unpause():
	hide()
	get_tree().paused = false

func _on_resume_pressed():
	unpause()

func _on_respawn_pressed():
	unpause()
	get_tree().reload_current_scene.bind().call_deferred()

func _on_quit_pressed():
	pass # TODO make this go to the title
