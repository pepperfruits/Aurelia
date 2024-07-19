extends CharacterBody2D
class_name PlayerCharacter

@export var Camera : Camera2D
@onready var movement : PlayerMovementNode = $Movement
@onready var InputHandler : InputHandler = $InputHandler

func _ready():
	set_camera_transition(false)

func _process(_delta):
	pass

func _on_player_entered_hook_range(hook : Hook):
	movement.hookArray.push_front(hook)

func _on_player_exited_hook_range(hook : Hook):
	movement.hookArray.erase(hook)

func set_camera_transition(enabled : bool) -> void:
	Camera.set_camera_transition(enabled)
