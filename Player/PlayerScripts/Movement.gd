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
## Dash particles
@onready var DashParticles : GPUParticles2D = $"../DashParticles"
## Collision shape
@onready var PlayerCollision : CollisionShape2D = $"../PlayerCollisionShape"
## timer for attack cooldown
@onready var AttackCooldownTimer : Timer = $AttackCooldownTimer
## The projectile you fire when attacking
@onready var PlayerBullet = preload("res://Projectiles/PlayerBullet/player_bullet.tscn")
## crystal timer, you go flying at 0
@onready var CrystalTimer : Timer = $CrystalTimer
## timer for when your particles fade away and you get more gravity back
@onready var CrystalDashTimer : Timer = $CrystalDashTimer
## particles for crystal dashes
@onready var CrystalParticles : GPUParticles2D = $"../CrystalParticles"
## audio player for the player's actions
@onready var Audio : PlayerAudio = $"../PlayerAudio"
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
@export var AIR_FRICTION_BONUS : float = 0.5
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
## the total time you can hold onto hooks
@export var MAX_STAMINA_TIME : float = 1.75
## how much time left you need for the player to start flashing
@export var FLASHING_STAMINA_TIME : float = 1.0
## bonus to your friction at max speed
@export var MAX_SPEED_FRICTION_BONUS : float = 0.75
## how much extra jump % you get when jumping from a hook
@export var HOOK_RELEASED_JUMP_BONUS : float = 1.2
## how fast you go out of a crystal
@export var CRYSTAL_VELOCITY : float = 4000.0
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
## True if you are holding jump, and hanging on a hook
var is_hanging : bool = false
## The current available hooks
var hook_array : Array[Hook] = []
## the current hook you are hanging onto, or grappling to
var current_hook : Hook = null
## List of hooks to refresh once you hit the ground
var hook_refresh_array : Array[Hook] = []
## possible states the player can be in
enum STATE {HANGING, GRAPPLING, DASHING, FALLING, RUNNING, IDLE, CRYSTAL}
## your current state
var current_state : STATE = STATE.IDLE
## true if you aren't on the ground, but you still have some time to coyote jump
var is_jump_coyote : bool = false
## true if you were just on the ground last frame
var was_on_floor : bool = false
## your current stamina time
var current_stamina : float = MAX_STAMINA_TIME
## if you can attack or not, based on cooldown
var is_attack_available : bool = true
## true if you are in a crystal
var is_crystal : bool = false
## your current crystal if you are in one
var current_crystal : Crystal = null
#endregion

func _process(delta):
	facing_direction = get_direction_facing()
	current_state = get_state()
	dashing_collision_changes()
	
	anim.set_direction(facing_direction)
	
	if (can_grapple() and inp.is_jump_inputted()): 
		grapple(delta)
	elif (can_attack() and inp.is_attack_inputted()):
		attack(facing_direction)
	elif (can_dash() and inp.is_dash_inputted()): 
		dash(inp.get_horizontal_input())
	elif (can_jump() and inp.is_jump_inputted()): 
		jump(1.0)
	
	match current_state:
		STATE.CRYSTAL:
			p.global_position = current_crystal.global_position
		STATE.HANGING:
			anim.hanging()
			current_stamina -= delta
			anim.low_stamina_flashing(current_stamina < FLASHING_STAMINA_TIME)
			if (not inp.is_jump_held() or current_hook.process_mode == PROCESS_MODE_DISABLED or current_stamina <= 0.0):
				hook_released()
			else:
				pull_towards_hook(delta)
		STATE.GRAPPLING:
			anim.hanging()
			if is_grapple_reached():
				grapple_reached()
				pull_towards_hook(delta)
			else:
				pull_towards_hook(delta)
		STATE.DASHING:
			pass
		STATE.FALLING:
			DashParticles.emitting = false
			anim.low_stamina_flashing(current_stamina < FLASHING_STAMINA_TIME)
			anim.fall(p.velocity.y)
			if (inp.get_horizontal_input()):
				apply_acceleration(delta, inp.get_horizontal_input())
			elif momentum != 0.0:
				apply_friction(delta)
		STATE.RUNNING:
			DashParticles.emitting = false
			anim.run()
			refresh_dash_charges()
			apply_acceleration(delta, inp.get_horizontal_input())
		STATE.IDLE:
			DashParticles.emitting = false
			refresh_dash_charges()
			if (momentum != 0.0):
				apply_friction(delta)
				if (abs(momentum) >= RUN_MAX_SPEED):
					anim.skid()
				else:
					anim.idle()
			else:
				anim.idle()
	
	run_physics(delta)

func dashing_collision_changes() -> void:
	if is_dashing:
		PlayerCollision.scale.y = 0.8
		PlayerCollision.position.y = 10
	else:
		PlayerCollision.scale.y = 1.0
		PlayerCollision.position.y = 27

func enter_crystal(c : Crystal) -> void:
	current_crystal = c
	current_state = STATE.CRYSTAL
	is_crystal = true
	is_hanging = false
	is_grappling = false
	if current_hook:
		hook_released()
	set_player_velocity(Vector2.ZERO)
	is_dashing = false
	CrystalTimer.start()
	anim.hide_player(true)

func leave_crystal():
	refresh_dash_charges()
	current_stamina = MAX_STAMINA_TIME
	var direction = inp.get_directional_input().normalized() * Vector2(1,-1)
	if not direction:
		direction = (current_crystal.PointerSprite.global_position - p.global_position).normalized()
	anim.hide_player(false)
	current_state = STATE.FALLING
	is_crystal = false
	set_player_velocity(direction * CRYSTAL_VELOCITY * Vector2(1.7, 1.0))
	current_crystal.use()
	current_crystal = null
	
	if ScoreManager.particles_enabled:
		CrystalParticles.emitting = true
	CrystalDashTimer.start()

func attack(facing : int):
	Audio.attack()
	
	anim.ranged_attack()
	var bullet = PlayerBullet.instantiate()
	if inp.get_horizontal_input():
		bullet.global_position = p.global_position + Vector2(50.0 * inp.get_horizontal_input(), -10.0)
		bullet.velocity.x *= inp.get_horizontal_input()
	else:
		bullet.global_position = p.global_position + Vector2(50.0 * facing, -10.0)
		bullet.velocity.x *= facing
	bullet.sender = p
	add_child(bullet)
	
	is_attack_available = false
	AttackCooldownTimer.start()

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
		DashParticles.emitting = false

func get_direction_facing() -> int:
	if (momentum > 1.0): 
		return 1
	elif (momentum < -1.0):
		return -1
	else:
		return facing_direction

func can_attack() -> bool:
	return is_attack_available and not is_hanging and not is_crystal

func get_state() -> STATE:
	if is_crystal:
		return STATE.CRYSTAL
	elif is_grappling and is_hanging:
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
		if not was_on_floor:
			anim.low_stamina_flashing(false)
			ground_refresh_hooks()
		return STATE.RUNNING
	else:
		if not was_on_floor:
			anim.low_stamina_flashing(false)
			ground_refresh_hooks()
		return STATE.IDLE

func ground_refresh_hooks() -> void:
	current_stamina = MAX_STAMINA_TIME
	for i : Hook in hook_refresh_array:
		i.ground_refresh()
	hook_refresh_array.clear()

func is_grapple_reached() -> bool:
	return current_hook.global_position.distance_to(p.global_position) < GRAPPLE_DEADZONE

func pull_towards_hook(delta : float) -> void:
	refresh_dash_charges()
	var difference = current_hook.global_position - p.global_position
	p.global_position += difference / GRAPPLE_TIME * delta + difference.normalized() * 30.0 * delta

func end_dash() -> void:
	is_dashing = false
	DashParticles.emitting = false

func set_player_velocity(velocity : Vector2) -> void:
	p.velocity = velocity
	momentum = velocity.x

func grapple_reached() -> void:
	momentum = 0.0
	p.velocity = Vector2.ZERO
	is_hanging = true

func hook_released() -> void:
	current_stamina = min(MAX_STAMINA_TIME, current_stamina + 1.0)
	
	hook_refresh_array.append(current_hook)
	is_hanging = false
	set_player_velocity(Vector2(inp.get_horizontal_input() * RUN_MAX_SPEED,0))
	is_grappling = false
	if inp.get_vertical_input() >= 0:
		jump(HOOK_RELEASED_JUMP_BONUS)
	else:
		refresh_dash_charges()
	
	current_hook.released()
	current_hook = null

func grapple(_delta) -> void:
	Audio.grapple()
	
	current_state = STATE.GRAPPLING
	set_player_velocity(Vector2.ZERO)
	end_dash()
	is_grappling = true
	
	current_hook = hook_array.pop_front()
	current_hook.use()

func can_grapple() -> bool:
	return not hook_array.is_empty() and not p.is_on_floor() and current_state != STATE.GRAPPLING and current_state != STATE.HANGING

func cap_momentum(delta : float) -> void:
	if (abs(momentum) > RUN_MAX_SPEED):
		apply_maxspeed_friction(delta)
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

func apply_maxspeed_friction(delta : float) -> void:
	if (p.is_on_floor()):
		momentum -= momentum * delta * FRICTION * MAX_SPEED_FRICTION_BONUS
	else:
		momentum -= momentum * delta * FRICTION * AIR_FRICTION_BONUS * MAX_SPEED_FRICTION_BONUS
	
	var movement_kill_zone : float = 4.0
	if (momentum < movement_kill_zone and momentum > -movement_kill_zone):
		momentum = 0.0

func apply_friction(delta : float) -> void:
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

func jump(multiplier : float) -> void:
	Audio.jump()
	is_jump_coyote = false
	current_state = STATE.FALLING
	end_dash()
	p.velocity.y = -JUMP_VELOCITY * multiplier
	refresh_dash_charges()
	inp._on_jump_buffer_timer_timeout()

func can_dash() -> bool:
	return current_dash_charges > 0 and is_dash_ready and not is_crystal and current_state != STATE.GRAPPLING

func dash(input_direction : float) -> void:
	Audio.dash()
	
	if is_hanging:
		hook_released()
	
	if ScoreManager.particles_enabled:
		DashParticles.emitting = true
	anim.dash(p.is_on_floor())
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

func _on_attack_cooldown_timer_timeout():
	is_attack_available = true

func _on_crystal_timer_timeout():
	leave_crystal()

func _on_crystal_dash_timer_timeout():
	CrystalParticles.emitting = false
#endregion
