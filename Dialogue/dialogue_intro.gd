extends Control
class_name Dialogue

@export var LAST_LINE : int = 7

var was_just_pressed : bool = false

var current_line : int = 1

func _ready():
	line(current_line)

func _process(_delta):
	if Input.is_anything_pressed() and not was_just_pressed:
		current_line += 1
		if current_line > LAST_LINE:
			queue_free()
		line(current_line)
	
	was_just_pressed = Input.is_anything_pressed()

func line(l : int):
	reset()
	match l:
		1:
			$Assets/AureliaTalking.visible = true
			$Lines/Line1.visible = true
		2:
			$Assets/Whisptalking.visible = true
			$Lines/Line2.visible = true
		3:
			$Assets/AureliaTalking.visible = true
			$Lines/Line3.visible = true
		4:
			$Assets/Whisptalking.visible = true
			$Lines/Line4.visible = true
		5:
			$Assets/AureliaTalking.visible = true
			$Lines/Line5.visible = true
		6:
			$Assets/Whisptalking.visible = true
			$Lines/Line6.visible = true
		7:
			$Assets/AureliaTalking.visible = true
			$Lines/Line7.visible = true

func reset():
	for i in $Assets.get_children():
		i.visible = false
	for i in $Lines.get_children():
		i.visible = false
