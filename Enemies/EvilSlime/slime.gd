extends CharacterBody2D
class_name Slime

@onready var spine : SpineSprite = $SpineSprite
@export var startingSkin : String

@export var SPEED : float = 200.0
@export var DEADZONE : float = 50.0

@export var Point1 : Marker2D
@export var Point2 : Marker2D

@export var BOUNCE_VELOCITY : float = 3000.0

var target_point : bool = true

func _ready():
	if $Spring:
		$Spring.SPRING_VELOCITY = BOUNCE_VELOCITY
	spine.get_skeleton().set_skin_by_name(startingSkin)
	spine.get_animation_state().set_animation("move", true, 0)

func _process(delta):
	if target_point:
		patrol(delta, Point1)
	else:
		patrol(delta, Point2)
	
	velocity.y = 0
	move_and_slide()

func patrol(_delta : float, point : Marker2D):
	var target_x = point.global_position.x
	var my_x = global_position.x
	
	if target_x > my_x:
		velocity.x = SPEED
		spine.get_skeleton().set_scale_x(1.0)
	else:
		velocity.x = -SPEED
		spine.get_skeleton().set_scale_x(-1.0)
	
	if abs(target_x - my_x) < DEADZONE:
		target_point = !target_point

func on_hurt():
	$AnimationPlayer.play("hurt")
