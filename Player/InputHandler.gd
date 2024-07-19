extends Node
class_name InputHandlerNode

@onready var JumpBufferTimer = $JumpBufferTimer
@onready var DashBufferTimer = $DashBufferTimer
@onready var DownBufferTimer = $DownBufferTimer

var is_jump_buffered : bool = false
var is_dash_buffered : bool = false
var is_down_buffered : bool = false

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		is_jump_buffered = true
		JumpBufferTimer.start()
	if Input.is_action_just_pressed("dash"):
		is_dash_buffered = true
		DashBufferTimer.start()
	if Input.is_action_just_pressed("move_down"):
		is_down_buffered = true
		DownBufferTimer.start()

func get_horizontal_input() -> float:
	return Input.get_axis("move_left", "move_right")

func get_vertical_input() -> float:
	return Input.get_axis("move_down", "move_up")

func is_jump_inputted() -> bool:
	return is_jump_buffered

func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func is_dash_inputted() -> bool:
	return is_dash_buffered

func _on_dash_buffer_timer_timeout():
	is_dash_buffered = false

func is_jump_held() -> bool:
	return Input.is_action_pressed("jump")

func _on_down_buffer_timer_timeout():
	is_down_buffered = false

func is_down_inputted() -> bool:
	return is_down_buffered
