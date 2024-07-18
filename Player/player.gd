extends CharacterBody2D
class_name PlayerCharacterBody2D

@onready var movement : PlayerMovementNode = $Movement

func _ready():
	pass 

func _process(_delta):
	pass

func _on_player_entered_hook_range(hook : HookArea2D):
	movement.hookArray.push_front(hook)

func _on_player_exited_hook_range(hook : HookArea2D):
	movement.hookArray.erase(hook)
