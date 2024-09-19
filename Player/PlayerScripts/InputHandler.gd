extends Node
class_name PlayerInputHandler

@onready var JumpBufferTimer = $JumpBufferTimer
@onready var DashBufferTimer = $DashBufferTimer
@onready var DownBufferTimer = $DownBufferTimer

var is_jump_buffered : bool = false
var is_dash_buffered : bool = false
var is_down_buffered : bool = false

@export var is_input_enabled : bool = false
var forced_horizontal_input : float = 0.0
var forced_vertical_input : float = 0.0

func _process(_delta):
	if is_input_enabled:
		if Input.is_action_just_pressed("jump"):
			is_jump_buffered = true
			JumpBufferTimer.start()
		if Input.is_action_just_pressed("dash"):
			is_dash_buffered = true
			DashBufferTimer.start()
		if Input.is_action_just_pressed("move_down"):
			is_down_buffered = true
			DownBufferTimer.start()

func get_directional_input() -> Vector2:
	return Vector2(get_horizontal_input(), get_vertical_input())

func get_horizontal_input() -> float:
	if is_input_enabled:
		var input = Input.get_axis("move_left", "move_right")
		if input > 0:
			return ceil(input)
		else:
			return floor(input)
	else:
		return forced_horizontal_input

func is_attack_inputted() -> float:
	if is_input_enabled:
		return Input.is_action_just_pressed("attack")
	else:
		return false

func get_vertical_input() -> float:
	if is_input_enabled:
		var input = Input.get_axis("move_down", "move_up")
		if input > 0:
			return ceil(input)
		else:
			return floor(input)
	else:
		return forced_vertical_input

func is_jump_inputted() -> bool:
	if is_input_enabled:
		return is_jump_buffered
	else:
		return false

func is_dash_inputted() -> bool:
	if is_input_enabled:
		return is_dash_buffered
	else:
		return false

func is_jump_held() -> bool:
	if is_input_enabled:
		return Input.is_action_pressed("jump")
	else:
		return false

func is_down_inputted() -> bool:
	if is_input_enabled:
		return is_down_buffered
	else:
		return false

func set_player_input(value : bool) -> void:
	is_input_enabled = value

func set_forced_horizontal_input(value : float) -> void:
	forced_horizontal_input = value

#region Signals
func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func _on_dash_buffer_timer_timeout():
	is_dash_buffered = false

func _on_down_buffer_timer_timeout():
	is_down_buffered = false
#endregion
