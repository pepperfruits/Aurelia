extends Camera2D

@export var p : CharacterBody2D
@export var CAMERA_SPEED : float = 10.0

@onready var transitionPlayer : AnimationPlayer = $TransitionAnimation
@onready var transitionMaterial : Material = $CanvasLayer/TransitionColor.material

var is_transition_enabled : bool = true
@export var transition_progress : float = 1.0

func _ready():
	$CanvasLayer.visible = true
	position = p.position
	set_camera_transition(false)

func _process(delta):
	position -= (global_position - p.global_position) * CAMERA_SPEED * delta
	transitionMaterial.set("shader_parameter/progress", transition_progress)

func set_camera_transition(to_enable_transition : bool) -> void:
	if transitionPlayer:
		if to_enable_transition:
			transitionPlayer.play("transition_fade_in")
		else:
			transitionPlayer.play("transition_fade_out")
