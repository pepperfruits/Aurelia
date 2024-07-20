extends Node
class_name PlayerMovementHandler

#region Onready Nodes
## For ease of programming, the player is just p
@onready var p : CharacterBody2D = $".." 
## Handles all input. For ease of programming, this is just inp
@onready var inp : PlayerInputHandler = $"../InputHandler"
## Handles all animations, for ease of programming its just anim
@onready var anim : PlayerAnimationHandler = $"../AnimationHandler"
## Duration of the dash
@onready var DashDurationTimer : Timer = $DashDurationTimer
## Cooldown for dashing
@onready var DashCooldownTimer : Timer = $DashCooldownTimer
## How long you have to jump after falling off a ledge
@onready var JumpCoyoteTimer : Timer = $JumpCoyoteTimer
## Same thing ^ but for dashing, where you can regain your dash after dashing off a ledge if you time it right
@onready var DashCoyoteTimer : Timer = $DashCoyoteTimer
#endregions

#region Export Constats
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
@export var JUMP_VELOCITY : float = 1050.0
## The velocity during your dash
@export var DASH_VELOCITY : float = 1400.0
## Your vertical velocity is multiplied by this when you dash
@export var DASH_VERTICAL_DAMPENING : float = 0.1
## How many dash charges you have max, and what it gets refreshed to on the ground
@export var MAX_DASH_CHARGES : int = 1
## How long it takes to grapple to a point
@export var GRAPPLE_TIME : float = 0.05
## How close being on top of a hook counts as finishing the grapple
@export var GRAPPLE_DEADZONE : float = 20.0
## how fast you can fall at max speed
@export var MAX_FALL_SPEED : float = 2000.0
#endregion

#region Variables
## This is the x momentum, the current x velocity. 
var momentum : float = 0.0
## If 0, not dashing. If non zero, this is the direction of the dash.
var is_dashing : bool = false
## Where you are facing last, only useful when not inputting a movement
var facing_direction : int = 1
## Your current dash charges
var current_dash_charges : int = 0
## Makes sure the cooldown is done
var is_dash_ready : bool = true
## True if you are grappling
var is_grappling : bool = false
## Where you want to reach when grappling to a hook
var grapple_target_position : Vector2 = Vector2.ZERO
## True if you are holding jump, and hanging on a hook
var is_hanging : bool = false
## The current available hooks
var hookArray : Array[Hook] = []
## possible states the player can be in
enum STATE {HANGING, GRAPPLING, DASHING, FALLING, RUNNING, IDLE}
## your current state
var current_state : STATE = STATE.IDLE
## true if you aren't on the ground, but you still have some time to coyote jump
var is_jump_coyote : bool = false
## true if you were just on the ground last frame
var was_on_floor : bool = false
#endregion

func _process(delta):
	facing_direction = get_direction_facing()
	current_state = get_state()
	
	anim.default(facing_direction) # remove this later, debug TODO
	
	if (can_dash()):
		$"../DashRect".color = Color.GREEN
	else:
		$"../DashRect".color = Color.BLACK
	if (can_jump()):
		$"../JumpRect".color = Color.GREEN
	else:
		$"../JumpRect".color = Color.BLACK
	
	if (can_grapple() and inp.is_jump_inputted()): 
		grapple(delta)
	elif (can_dash() and inp.is_dash_inputted()): 
		dash(inp.get_horizontal_input())
	elif (can_jump() and inp.is_jump_inputted()): 
		jump(delta)
	
	match current_state:
		STATE.HANGING:
			if (not inp.is_jump_held()):
				hook_released(delta)
			else:
				pull_towards_hook(delta)
		STATE.GRAPPLING:
			if is_grapple_reached():
				grapple_reached(delta)
			else:
				pull_towards_hook(delta)
		STATE.DASHING:
			anim.dashing(facing_direction)
		STATE.FALLING:
			if (inp.get_horizontal_input()):
				apply_acceleration(delta, inp.get_horizontal_input())
			else:
				apply_friction(delta)
		STATE.RUNNING:
			refresh_dash_charges()
			apply_acceleration(delta, inp.get_horizontal_input())
		STATE.IDLE:
			refresh_dash_charges()
			apply_friction(delta)
	
	run_physics(delta)

#region Helper Functions
func run_physics(delta):
	was_on_floor = p.is_on_floor()
	p.velocity.x = momentum
	
	if current_state == STATE.FALLING:
		apply_half_gravity(delta)
	
	p.move_and_slide()
	
	if current_state == STATE.FALLING:
		apply_half_gravity(delta)
	
	momentum = p.velocity.x
	if abs(momentum) < 1.0: # Stop the dash early if you aren't moving anymore (hit a wall)
		is_dashing = false

func get_direction_facing() -> int:
	if (momentum > 1.0): 
		return 1
	elif (momentum < -1.0):
		return -1
	else:
		return facing_direction

func get_state() -> STATE:
	if is_grappling and is_hanging:
		return STATE.HANGING
	elif is_grappling:
		return STATE.GRAPPLING
	elif is_dashing:
		if (was_on_floor and not p.is_on_floor()):
			is_jump_coyote = true
			JumpCoyoteTimer.start()
		return STATE.DASHING
	elif not p.is_on_floor():
		if (was_on_floor and p.velocity.y >= 0):
			is_jump_coyote = true
			JumpCoyoteTimer.start()
		return STATE.FALLING
	elif inp.get_horizontal_input():
		return STATE.RUNNING
	else:
		return STATE.IDLE

func is_grapple_reached() -> bool:
	return grapple_target_position.distance_to(p.global_position) < GRAPPLE_DEADZONE

func pull_towards_hook(delta : float) -> void:
	p.global_position += (grapple_target_position - p.global_position) / GRAPPLE_TIME * delta

func end_dash() -> void:
	is_dashing = false

func set_player_velocity(velocity : Vector2) -> void:
	p.velocity = velocity
	momentum = velocity.x

func grapple_reached(_delta) -> void:
	momentum = 0.0
	p.velocity = Vector2.ZERO
	is_hanging = true

func hook_released(delta) -> void:
	is_hanging = false
	if inp.get_vertical_input() < 0:
		is_grappling = false
	else:
		set_player_velocity(Vector2(inp.get_horizontal_input() * RUN_MAX_SPEED,0))
		jump(delta)
		is_grappling = false

func grapple(_delta) -> void:
	current_state = STATE.GRAPPLING
	set_player_velocity(Vector2.ZERO)
	end_dash()
	
	grapple_target_position = hookArray.front().global_position
	is_grappling = true
	hookArray.front().use()
	hookArray.pop_front()

func can_grapple() -> bool:
	return not hookArray.is_empty() and not p.is_on_floor() and current_state != STATE.GRAPPLING and current_state != STATE.HANGING

func cap_momentum(delta : float) -> void:
	if (abs(momentum) > RUN_MAX_SPEED):
		apply_friction(delta) # TODO can be a separate friction function, optionally
		if (momentum > 0):
			momentum = max(momentum, RUN_MAX_SPEED)
		else:
			momentum = min(momentum, -RUN_MAX_SPEED)

func apply_acceleration(delta : float, input_direction : float) -> void:
	var percent_of_max_speed : float = momentum / RUN_MAX_SPEED
	var pivot_bonus : float = 1.0
	if ((input_direction > 0 and percent_of_max_speed < 0) or (input_direction < 0 and percent_of_max_speed > 0)):
		pivot_bonus += PIVOT_ACCEL_BONUS * min(abs(percent_of_max_speed), 1.0)
	
	if (p.is_on_floor()):
		momentum += input_direction * RUN_ACCEL * delta * pivot_bonus
	else:
		momentum += input_direction * RUN_ACCEL * delta * AIR_ACCEL_BONUS * pivot_bonus
	
	cap_momentum(delta)

func apply_friction(delta : float) -> void:
	if (momentum != 0.0):
		if (p.is_on_floor()):
			momentum -= momentum * delta * FRICTION
		else:
			momentum -= momentum * delta * FRICTION * AIR_FRICTION_BONUS
		
		var movement_kill_zone : float = 4.0
		if (momentum < movement_kill_zone and momentum > -movement_kill_zone):
			momentum = 0.0

func apply_half_gravity(delta : float) -> void:
	p.velocity.y += GRAVITY * delta * 0.5
	if p.velocity.y > MAX_FALL_SPEED:
		p.velocity.y = MAX_FALL_SPEED

func can_jump() -> bool:
	return p.is_on_floor() or is_jump_coyote

func jump(_delta : float) -> void:
	is_jump_coyote = false
	current_state = STATE.FALLING
	end_dash()
	p.velocity.y = -JUMP_VELOCITY
	refresh_dash_charges()
	inp._on_jump_buffer_timer_timeout()

func can_dash() -> bool:
	return current_dash_charges > 0 and is_dash_ready and current_state != STATE.GRAPPLING and current_state != STATE.HANGING

func dash(input_direction : float) -> void:
	current_state = STATE.DASHING
	is_dashing = true
	DashDurationTimer.start()
	DashCooldownTimer.start()
	p.velocity.y *= DASH_VERTICAL_DAMPENING
	current_dash_charges -= 1
	is_dash_ready = false
	DashCoyoteTimer.start()
	
	if input_direction:
		momentum = input_direction * DASH_VELOCITY
	else:
		momentum = facing_direction * DASH_VELOCITY

func refresh_dash_charges() -> void:
	current_dash_charges = MAX_DASH_CHARGES
#endregion

#region Signals
func _on_dash_duration_timer_timeout():
	is_dashing = false

func _on_dash_cooldown_timer_timeout():
	is_dash_ready = true

func _on_jump_coyote_timer_timeout():
	is_jump_coyote = false

func _on_dash_coyote_timer_timeout():
	if p.is_on_floor():
		refresh_dash_charges()
#endregion
