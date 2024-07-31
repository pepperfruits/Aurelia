extends Control

func _ready():
	$ColorRect/Icons/coins.text = "[color=#7be4ef]" + str(ScoreManager.coins) + "		/		" + str(ScoreManager.MAX_COINS) + "[/color]"
	$ColorRect/Icons/deaths.text = "[color=#e9ffff]" + str(ScoreManager.deaths) + "	[/color]"
	$ColorRect/Clock/time.text = "[color=#ffca6d]" + seconds_to_text(ScoreManager.time) + "	[/color]"

func seconds_to_text(time : float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 1000)
	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
