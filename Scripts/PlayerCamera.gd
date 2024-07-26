extends Camera2D
class_name PlayerCamera

@export var p : CharacterBody2D
@export var CAMERA_SPEED : float = 10.0
@export var DEFAULT_ZOOM : Vector2 = Vector2(1,1)

@onready var transitionPlayer : AnimationPlayer = $TransitionAnimation
@onready var transitionMaterial : Material = $CanvasLayer/TransitionColor.material

var is_transition_enabled : bool = true
@export var transition_progress : float = 1.0

var camera_area : CameraControlArea = null
var old_zoom : Vector2 = DEFAULT_ZOOM

func _ready():
	$CanvasLayer.visible = true
	position = p.position
	set_camera_transition(false)

func add_camera_area(c : CameraControlArea):
	old_zoom = zoom
	camera_area = c

func remove_camera_area():
	camera_area = null

func _process(delta):
	if camera_area:
		position -= (global_position - camera_area.global_position) * CAMERA_SPEED * delta * 0.3
		zoom += (camera_area.zoom - zoom) * delta
	else:
		position -= (global_position - p.global_position) * CAMERA_SPEED * delta
		zoom += (old_zoom - zoom) * delta
	
	transitionMaterial.set("shader_parameter/progress", transition_progress)

func set_camera_transition(to_enable_transition : bool) -> void:
	if transitionPlayer:
		if to_enable_transition:
			transitionPlayer.play("transition_fade_in")
		else:
			transitionPlayer.play("transition_fade_out")
