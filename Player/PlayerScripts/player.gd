extends CharacterBody2D
class_name PlayerCharacter

@export var Camera : Camera2D
@onready var Movement : PlayerMovementHandler = $Movement
@onready var InputHandler : PlayerInputHandler = $InputHandler

func _process(_delta):
	pass

func _on_player_entered_hook_range(hook : Hook):
	Movement.hookArray.push_front(hook)

func _on_player_exited_hook_range(hook : Hook):
	Movement.hookArray.erase(hook)

func set_camera_transition(enabled : bool) -> void:
	Camera.set_camera_transition(enabled)

func refresh_dash_charges() -> void:
	Movement.refresh_dash_charges()

func set_player_velocity(new_velocity : Vector2) -> void:
	Movement.set_player_velocity(new_velocity)

func end_dash() -> void:
	Movement.end_dash()
