extends Camera2D

@export var p : CharacterBody2D
@export var CAMERA_SPEED : float = 10.0


func _ready():
	position = p.position


func _process(delta):
	position -= (position - p.position) * CAMERA_SPEED * delta
