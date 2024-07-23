extends CharacterBody2D
class_name PlayerCharacter

@export var Camera : Camera2D
@onready var Movement : PlayerMovementHandler = $Movement
@onready var InputHandler : PlayerInputHandler = $InputHandler

func _process(_delta):
	pass

func ground_refresh_hooks() -> void:
	Movement.ground_refresh_hooks()

func _on_player_entered_hook_range(hook : Hook) -> void:
	Movement.hook_array.push_front(hook)

func _on_player_exited_hook_range(hook : Hook):
	Movement.hook_array.erase(hook)

func set_camera_transition(enabled : bool) -> void:
	Camera.set_camera_transition(enabled)

func refresh_dash_charges() -> void:
	Movement.refresh_dash_charges()

func set_player_velocity(new_velocity : Vector2) -> void:
	Movement.set_player_velocity(new_velocity)

func end_dash() -> void:
	Movement.end_dash()

func set_player_input(value : bool) -> void:
	InputHandler.set_player_input(value)

func set_forced_horizontal_input(value : float) -> void:
	InputHandler.set_forced_horizontal_input(value)
