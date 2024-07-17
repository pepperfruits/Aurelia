extends Node

#region Nodes
## For ease of programming, the player is p
@onready var p : CharacterBody2D = $".." 
#endregion

#region Constants
@export var RUN_ACCEL : float = 800.0
@export var AIR_ACCEL_BONUS : float = 0.75
@export var RUN_MAX_SPEED : float = 400.0
@export var FRICTION : float = 8.0
@export var AIR_FRICTION_BONUS : float = 0.75
#endregion

#region Variables
var momentum : float = 0.0
#endregion

func _process(delta):
	var is_on_floor : bool = p.is_on_floor()
	var input_direction : float = Input.get_axis("move_left", "move_right")
	
	# Movement Acc
	if (input_direction):
		apply_acceleration(delta, input_direction, is_on_floor)
	else:
		apply_friction(delta, is_on_floor)
	
	$"../DebugLabel".text = str(momentum) # TODO debug, delete
	p.velocity.x = momentum
	p.move_and_slide()

func cap_momentum(_delta : float) -> void:
	momentum = min(momentum, RUN_MAX_SPEED)
	momentum = max(momentum, -RUN_MAX_SPEED)

func apply_acceleration(delta : float, input_direction : float, is_on_floor : bool) -> void:
	if (is_on_floor):
		momentum += input_direction * RUN_ACCEL * delta
	else:
		momentum += input_direction * RUN_ACCEL * delta * AIR_ACCEL_BONUS
	
	cap_momentum(delta)

func apply_friction(delta : float, is_on_floor : bool) -> void:
	if (momentum != 0.0):
		if (is_on_floor):
			momentum -= momentum * delta * FRICTION
		else:
			momentum -= momentum * delta * FRICTION * AIR_FRICTION_BONUS
		
		var movement_kill_zone : float = 4.0
		if (momentum < movement_kill_zone and momentum > -movement_kill_zone):
			momentum = 0.0
