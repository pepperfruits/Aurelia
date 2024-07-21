extends RichTextLabel

func _process(delta):
	text = "Deaths: " + str(ScoreManager.deaths)
	
