extends Node
class_name PlayerAnimationHandler

## possible states the player can be in
enum STATE {HANGING, GRAPPLING, DASHING, FALLING, RUNNING, IDLE}
## your current state
var current_state : STATE = STATE.IDLE

# This whole handler is temporary until we have spine set up TODO

func default(direction : int) -> void:
	$"../PlaceHolderSprite".scale.x = 0.248 * direction 
	$"../PlaceHolderSprite".rotation_degrees = 0 

func dashing(direction : int) -> void:
	if (direction == 1):
		$"../PlaceHolderSprite".rotation_degrees = 80 # TODO remove, debug!
	else:
		$"../PlaceHolderSprite".rotation_degrees = -80 # TODO remove, debug!
