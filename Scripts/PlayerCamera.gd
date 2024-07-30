extends Camera2D
class_name PlayerCamera

@export var p : CharacterBody2D
@export var CAMERA_SPEED : float = 10.0
@export var DEFAULT_ZOOM : Vector2 = Vector2(1,1)

@export var CAMERA_MIX : float = 0.4

@onready var transitionPlayer : AnimationPlayer = $TransitionAnimation
@onready var transitionMaterial : Material = $CanvasLayer/TransitionColor.material

var is_transition_enabled : bool = true
@export var transition_progress : float = 1.0

var camera_area : CameraControlArea = null

@export var SWAP_SPEED : float = 0.4

func _ready():
	$CanvasLayer.visible = true
	position = p.position
	set_camera_transition(false)

func add_camera_area(c : CameraControlArea):
	camera_area = c

func remove_camera_area(c : CameraControlArea):
	if camera_area == c:
		camera_area = null

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		$CanvasLayer/PauseMenu.pause()
	
	if camera_area:
		var target_position : Vector2 = p.global_position * (1.0 - CAMERA_MIX) + camera_area.marker.global_position * (CAMERA_MIX)
		global_position += (target_position - global_position) * CAMERA_SPEED * delta * 0.3
		zoom += (camera_area.zoom - zoom) * delta
	else:
		position -= (global_position - p.global_position) * CAMERA_SPEED * delta * SWAP_SPEED
		zoom += (DEFAULT_ZOOM - zoom) * delta * SWAP_SPEED
	
	transitionMaterial.set("shader_parameter/progress", transition_progress)

func set_camera_transition(to_enable_transition : bool) -> void:
	if transitionPlayer:
		if to_enable_transition:
			transitionPlayer.play("transition_fade_in")
		else:
			transitionPlayer.play("transition_fade_out")
