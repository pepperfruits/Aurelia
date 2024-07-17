extends Node
class_name PlayerMovementNode

#region Nodes
## For ease of programming, the player is p
@onready var p : CharacterBody2D = $".." 
## Handles all input
@onready var InputHandler : InputHandlerNode = $"../InputHandler"
#endregion

#region Constants
@export var RUN_ACCEL : float = 1700.0
@export var RUN_MAX_SPEED : float = 500.0
@export var AIR_ACCEL_BONUS : float = 1.0
@export var PIVOT_ACCEL_BONUS : float = 3.0

@export var FRICTION : float = 8.0
@export var AIR_FRICTION_BONUS : float = 0.5

@export var GRAVITY : float = 2000.0

@export var JUMP_VELOCITY : float = 1000.0
#endregion

#region Variables
## This is the x momentum, the current x velocity. 
var momentum : float = 0.0
#endregion

func _process(delta):
	var is_on_floor : bool = p.is_on_floor()
	var input_direction : float = InputHandler.get_horizontal_input() # 1 = right, -1 = left
	
	# If input is left or right,
	if (input_direction):
		apply_acceleration(delta, input_direction, is_on_floor)
	else: # Otherwise, apply friction to stop
		apply_friction(delta, is_on_floor)
	
	# If Jumping:
	if (can_jump() and InputHandler.is_jump_inputted()):
		jump(delta)
	else: # Otherwise, check if gravity should be applied
		if (is_on_floor):
			pass
		else:
			apply_gravity(delta)
	
	#$"../DebugLabel".text = str(momentum) # DEBUG
	p.velocity.x = momentum
	p.move_and_slide()

#region Helper Functions
func cap_momentum(delta : float, is_on_floor : bool) -> void:
	if (abs(momentum) > RUN_MAX_SPEED):
		apply_friction(delta, is_on_floor)
		if (momentum > 0):
			momentum = max(momentum, RUN_MAX_SPEED)
		else:
			momentum = min(momentum, -RUN_MAX_SPEED)

func apply_acceleration(delta : float, input_direction : float, is_on_floor : bool) -> void:
	var percent_of_max_speed = momentum / RUN_MAX_SPEED
	var pivot_bonus = 1.0
	if ((input_direction > 0 and percent_of_max_speed < 0) or (input_direction < 0 and percent_of_max_speed > 0)):
		pivot_bonus += PIVOT_ACCEL_BONUS * min(abs(percent_of_max_speed), 1.0)
	
	if (is_on_floor):
		momentum += input_direction * RUN_ACCEL * delta * pivot_bonus
	else:
		momentum += input_direction * RUN_ACCEL * delta * AIR_ACCEL_BONUS * pivot_bonus
	
	cap_momentum(delta, is_on_floor)

func apply_friction(delta : float, is_on_floor : bool) -> void:
	if (momentum != 0.0):
		if (is_on_floor):
			momentum -= momentum * delta * FRICTION
		else:
			momentum -= momentum * delta * FRICTION * AIR_FRICTION_BONUS
		
		var movement_kill_zone : float = 4.0
		if (momentum < movement_kill_zone and momentum > -movement_kill_zone):
			momentum = 0.0

func apply_gravity(delta : float) -> void:
	p.velocity.y += GRAVITY * delta

func can_jump() -> bool:
	return p.is_on_floor()

func jump(_delta : float) -> void:
	p.velocity.y = -JUMP_VELOCITY
#endregion
