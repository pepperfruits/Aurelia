extends SpineSprite
class_name PlayerAnimationHandler

@export var flashing_cycle_rate : float = 3.0

## possible states the player can be in
enum STATE {HANGING, GRAPPLING, DASHING, FALLING, RUNNING, IDLE}
## your current state
var current_state : STATE = STATE.IDLE
## if you are flashing from low stamina
var is_low_stamina_flashing : bool = false
## what time 0-1 that you are in the flashing cycle
var flashing_cycle_time : float = 0.0

# This whole handler is temporary until we have spine set up TODO

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

func default(direction : int) -> void:
	scale.x = 0.248 * direction 
	rotation_degrees = 0 

func dashing(direction : int) -> void:
	if (direction == 1):
		rotation_degrees = 80 # TODO remove, debug!
	else:
		rotation_degrees = -80 # TODO remove, debug!
