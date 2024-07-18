extends Node
class_name PlayerMovementNode

#region Nodes
## For ease of programming, the player is p
@onready var p : CharacterBody2D = $".." 
## Handles all input
@onready var InputHandler : InputHandlerNode = $"../InputHandler"
## Duration of the dash
@onready var DashDurationTimer : Timer = $DashDurationTimer
## Cooldown for dashing
@onready var DashCooldownTimer : Timer = $DashCooldownTimer
#endregion

#region Constants
## Acceleration from running in a direction (grounded)
@export var RUN_ACCEL : float = 1700.0
## Your max speed from running normally/midair movement
@export var RUN_MAX_SPEED : float = 500.0
## How much you accelerate slower or faster in air
@export var AIR_ACCEL_BONUS : float = 1.0
## How much faster you accelerate when pivoting from side to side
@export var PIVOT_ACCEL_BONUS : float = 3.0

## How much friction is applied when stopping (no directional input)
@export var FRICTION : float = 8.0
## How much stronger/weaker your friction is when midair
@export var AIR_FRICTION_BONUS : float = 1.0

## Acceleration due to gravity
@export var GRAVITY : float = 2000.0

## The velocity upwards when you first jump
@export var JUMP_VELOCITY : float = 1000.0

## The velocity during your dash
@export var DASH_VELOCITY : float = 1400.0
## Your vertical velocity is multiplied by this when you dash
@export var DASH_VERTICAL_DAMPENING : float = 0.1

## How many dash charges you have max, and what it gets refreshed to on the ground
@export var MAX_DASH_CHARGES : int = 1

## How long it takes to grapple to a point
@export var GRAPPLE_TIME : float = 0.05
## How close being on top of a hook counts as finishing the grapple
@export var GRAPPLE_DEADZONE : float = 1.0
#endregion

#region Variables
## This is the x momentum, the current x velocity. 
var momentum : float = 0.0
## If 0, not dashing. If non zero, this is the direction of the dash.
var dashing : int = 0
## Where you are facing last, only useful when not inputting a movement
var facing : int = 1
## Your current dash charges
var dash_charges : int = 0
## Makes sure the cooldown is done
var is_dash_ready : bool = true
## True if you are grappling
var grappling : bool = false
## Where you want to reach when grappling to a hook
var grapple_target_position : Vector2 = Vector2.ZERO
## True if you are holding jump, and hanging on a hook
var hanging : bool = false
## The current available hooks
var hookArray : Array[HookArea2D] = []
#endregion

func _process(delta):
	$"../PlaceHolderSprite".scale.x = 0.49 * facing # TODO remove, debug!
	$"../PlaceHolderSprite".rotation_degrees = 0 # TODO remove, debug!
	
	var is_on_floor : bool = p.is_on_floor()
	var input_direction : float = InputHandler.get_horizontal_input() # 1 = right, -1 = left
	if (momentum > 1.0): 
		facing = 1
	elif (momentum < -1.0):
		facing = -1
	
	if (can_grapple(is_on_floor) and InputHandler.is_jump_inputted()): # If you can grapple, grapple
		grapple(delta)
	
	if grappling:
		if hanging:
			if (not InputHandler.is_jump_held()):
				hook_released(delta)
		else:
			if grapple_target_position.distance_to(p.position) < GRAPPLE_DEADZONE:
				grapple_reached(delta)
			else:
				p.position += (grapple_target_position - p.position) / GRAPPLE_TIME * delta
	else:
		if (can_dash() and InputHandler.is_dash_inputted()): # If you can dash, dash
			dash(input_direction, delta)
		if dashing: #If you are dashing, TODO it does some debug stuff!
			if (facing == 1):
				$"../PlaceHolderSprite".rotation_degrees = 80 # TODO remove, debug!
			else:
				$"../PlaceHolderSprite".rotation_degrees = -80 # TODO remove, debug!
		else: #If you aren't dashing, then handle movement inputs & gravity
			if (input_direction): # If input is left or right, apply acceleration
				apply_acceleration(delta, input_direction, is_on_floor)
			else: # Otherwise, apply friction to stop
				apply_friction(delta, is_on_floor)
			
			if (can_jump() and InputHandler.is_jump_inputted()): # If you can jump, jump. 
				jump(delta)
			else: # Otherwise, check if gravity should be applied or if we should refresh dash(es) anyway
				if (is_on_floor):
					refresh_dash_charges()
				else:
					apply_gravity(delta)
	
	p.velocity.x = momentum
	p.move_and_slide()
	momentum = p.velocity.x
	if abs(momentum) < 1.0: # Stop the dash early if you aren't moving anymore (hit a wall)
		dashing = 0

#region Helper Functions
func grapple_reached(delta) -> void:
	momentum = 0.0
	p.velocity = Vector2.ZERO
	hanging = true

func hook_released(delta) -> void:
	hanging = false
	if InputHandler.get_vertical_input() < 0:
		grappling = false
	else:
		jump(delta)
		grappling = false

func grapple(_delta) -> void:
	momentum = 0
	p.velocity = Vector2.ZERO
	grapple_target_position = hookArray.front().global_position
	grappling = true
	dashing = false
	hookArray.front().use()

func can_grapple(is_on_floor : bool) -> bool:
	return not hookArray.is_empty() and not is_on_floor

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
	refresh_dash_charges()
	InputHandler._on_jump_buffer_timer_timeout()

func can_dash() -> bool:
	return dash_charges > 0 and is_dash_ready

func dash(input_direction : float, _delta : float) -> void:
	dashing = true
	DashDurationTimer.start()
	DashCooldownTimer.start()
	p.velocity.y *= DASH_VERTICAL_DAMPENING
	dash_charges -= 1
	is_dash_ready = false
	
	if input_direction:
		momentum = input_direction * DASH_VELOCITY
	else:
		momentum = facing * DASH_VELOCITY

func refresh_dash_charges() -> void:
	dash_charges = MAX_DASH_CHARGES

#endregion

#region Signals
func _on_dash_duration_timer_timeout():
	dashing = false

func _on_dash_cooldown_timer_timeout():
	is_dash_ready = true
#endregion
