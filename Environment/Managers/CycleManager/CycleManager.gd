extends Node2D
class_name CycleManager

@export var CYCLE_TIME : float = 5.0

var time : float = 0.0
var firstFrame : bool = true

func _process(delta):
	firstFrame = false
	time += delta / CYCLE_TIME
	if time > 1.0:
		time -= 1.0
		firstFrame = true

