extends Node
class_name InputHandlerNode

@onready var JumpBufferTimer = $JumpBufferTimer
@onready var DashBufferTimer = $DashBufferTimer

var is_jump_buffered : bool = false
var is_dash_buffered : bool = false

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		is_jump_buffered = true
		JumpBufferTimer.start()
	if Input.is_action_just_pressed("dash"):
		is_dash_buffered = true
		DashBufferTimer.start()

func get_horizontal_input() -> float:
	return Input.get_axis("move_left", "move_right")

func is_jump_inputted() -> bool:
	return is_jump_buffered

func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func is_dash_inputted() -> bool:
	return is_dash_buffered

func _on_dash_buffer_timer_timeout():
	is_dash_buffered = false
