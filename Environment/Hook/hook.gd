extends Area2D
class_name HookArea2D

@onready var p : PlayerCharacterBody2D = $"..".p

func _ready():
	pass

func _on_body_entered(body : PlayerCharacterBody2D):
	body._on_player_entered_hook_range(self)

func _on_body_exited(body : PlayerCharacterBody2D):
	body._on_player_exited_hook_range(self)
