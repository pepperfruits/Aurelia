extends Node

var level1_music = load("res://Audio/Music/BGM.wav")
var mainmenu_music = load("res://Audio/Music/mainmenu.wav")

func _ready():
	pass

func play_menu_music():
	$Music.stream = mainmenu_music
	$Music.play()

func play_music():
	$Music.stream = level1_music
	$Music.play()

func _on_music_finished():
	$Music.play()
