extends CharacterBody2D
class_name PlayerCharacterBody2D

@export var Camera : Camera2D
@onready var movement : PlayerMovementNode = $Movement

func _ready():
	set_camera_transition(false)

func _process(_delta):
	pass

func _on_player_entered_hook_range(hook : HookArea2D):
	movement.hookArray.push_front(hook)

func _on_player_exited_hook_range(hook : HookArea2D):
	movement.hookArray.erase(hook)

func set_camera_transition(enabled : bool) -> void:
	Camera.set_camera_transition(enabled)
