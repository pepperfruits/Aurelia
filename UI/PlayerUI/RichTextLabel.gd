extends RichTextLabel

func _process(_delta):
	text = "Deaths: " + str(ScoreManager.deaths)

