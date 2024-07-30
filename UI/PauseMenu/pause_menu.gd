extends Control
class_name PauseMenu

@export_file(".tscn") var main_menu_scene : String

func pause():
	show()
	get_tree().paused = true
	$Icons/coins.text = "[color=#7be4ef]" + str(ScoreManager.coins) + "		/		" + str(ScoreManager.MAX_COINS) + "[/color]"
	$Icons/deaths.text = "[color=#e9ffff]" + str(ScoreManager.deaths) + "	[/color]"
	$Icons/Clock/time.text = "[color=#ffca6d]" + seconds_to_text(ScoreManager.time) + "[/color]"

func unpause():
	hide()
	get_tree().paused = false

func _on_resume_pressed():
	unpause()

func _on_respawn_pressed():
	unpause()
	get_tree().reload_current_scene.bind().call_deferred()

func _on_quit_pressed():
	get_tree().paused = false
	ScoreManager.restart()
	get_tree().change_scene_to_file(main_menu_scene)

func seconds_to_text(time : float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 1000)
	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
