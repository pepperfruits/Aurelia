extends SpineSprite
class_name PlayerAnimationHandler

@onready var a : SpineAnimationState = get_animation_state()
@export var flashing_cycle_rate : float = 3.0

## if you are flashing from low stamina
var is_low_stamina_flashing : bool = false
## what time 0-1 that you are in the flashing cycle
var flashing_cycle_time : float = 0.0

@export var BLINK_TRACK_INDEX : int = 0
@export var MOVEMENT_TRACK_INDEX : int = 1

func _ready():
	a.set_animation("Blink", true, BLINK_TRACK_INDEX)
	a.set_animation("Run", true, MOVEMENT_TRACK_INDEX)

func _process(delta):
	if is_low_stamina_flashing:
		flashing_cycle_time += delta * flashing_cycle_rate
		if (flashing_cycle_time > 1.0):
			flashing_cycle_time -= 1.0
		normal_material.set("shader_parameter/redness", abs(sin(flashing_cycle_time * PI)))

func low_stamina_flashing(enabled : bool):
	is_low_stamina_flashing = enabled
	if not enabled:
		normal_material.set("shader_parameter/redness", 0.0)

func set_direction(direction : int) -> void:
	scale.x = abs(scale.x) * direction 

func change_animation(animation_name : String, looping : bool, id : int) -> void:
	if a.get_current(1).get_animation().get_name() != animation_name:
		a.set_animation(animation_name, looping, id)

func idle() -> void:
	change_animation("Idle", true, MOVEMENT_TRACK_INDEX)

func run() -> void:
	change_animation("Run", true, MOVEMENT_TRACK_INDEX)
