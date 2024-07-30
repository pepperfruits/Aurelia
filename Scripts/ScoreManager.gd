extends Node

var deaths : int = 0
var coins : int = 0
var MAX_COINS : int = 10
var time : float = 0.0
var particles_enabled : bool = true

var control_scheme : int = 0

var coinArray : Array[int] = []

func restart():
	deaths = 0
	coins = 0
	time = 0.0
	particles_enabled = true
	control_scheme = 0
	coinArray.clear()
