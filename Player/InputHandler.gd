extends Node
class_name InputHandler

func get_horizontal_input() -> float:
	return Input.get_axis("move_left", "move_right")

func is_jump_inputted() -> bool:
	return Input.is_action_just_pressed("jump")
