extends RichTextLabel

func _process(_delta):
	text = "Deaths: " + str(ScoreManager.deaths) + "\nCoins: " + str(ScoreManager.coins) + "/" + str(ScoreManager.MAX_COINS)

