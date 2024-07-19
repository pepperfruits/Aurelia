extends Camera2D

@export var p : CharacterBody2D
@export var CAMERA_SPEED : float = 10.0

@export var transitionWidth : int = 5984
@export var transitionEnabledX : int = -1250
@export var transitionDisabledX : int = 2500
@export var TRANSITION_SPEED : float = 2.0
@onready var transition : Sprite2D = $TransitionSprite

var is_transition_enabled : bool = true

func _ready():
	transition.visible = true
	position = p.position
	transition.offset.x = transitionEnabledX


func _physics_process(delta):
	position -= (position - p.position) * CAMERA_SPEED * delta
	
	if is_transition_enabled:
		transition.offset.x += (transitionEnabledX - transition.offset.x) * delta * TRANSITION_SPEED
	else: 
		transition.offset.x += (transitionDisabledX - transition.offset.x) * delta * TRANSITION_SPEED

func set_camera_transition(to_enable_transition : bool) -> void:
	is_transition_enabled = to_enable_transition
