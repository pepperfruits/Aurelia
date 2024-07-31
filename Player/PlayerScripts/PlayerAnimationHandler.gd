extends SpineSprite
class_name PlayerAnimationHandler

@onready var a : SpineAnimationState = get_animation_state()
@onready var Audio : PlayerAudio = $"../PlayerAudio"
@export var flashing_cycle_rate : float = 3.0

## if you are flashing from low stamina
var is_low_stamina_flashing : bool = false
## what time 0-1 that you are in the flashing cycle
var flashing_cycle_time : float = 0.0

@export var BLINK_TRACK_INDEX : int = 0
@export var MOVEMENT_TRACK_INDEX : int = 1
@export var ATTACK_TRACK_INDEX : int = 2
@export var APEX_RANGE : float = 150.0

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
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != animation_name:
		a.set_animation(animation_name, looping, id)

func idle() -> void:
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != "DashEnd" and last_animation != "StaffDash" and last_animation != "DashEndDescend":
		change_animation("Idle", true, MOVEMENT_TRACK_INDEX)

func run() -> void:
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != "DashEnd" and last_animation != "StaffDash" and last_animation != "DashEndDescend":
		change_animation("Run", true, MOVEMENT_TRACK_INDEX)

func skid() -> void:
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != "DashEnd" and last_animation != "StaffDash":
		change_animation("Skid", false, MOVEMENT_TRACK_INDEX)

func dash(on_ground : bool) -> void:
	if on_ground:
		a.set_animation("StaffDash", true, 1)
		a.add_animation("DashEnd", 0.15, false, 1)
		a.add_animation("Skid", 0.3, false, 1)
	else:
		a.set_animation("StaffDash", true, 1)
		a.add_animation("DashEndDescend", 0.15, false, 1)
		a.add_animation("Descend", 0.3, false, 1)

func hanging() -> void:
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != "Hanging" and last_animation != "Grapple":
		change_animation("Grapple", true, MOVEMENT_TRACK_INDEX)
		a.add_animation("Hanging", 0.01, true, MOVEMENT_TRACK_INDEX)

func fall(y_velocity : float) -> void:
	var last_animation = a.get_current(1).get_animation().get_name()
	if last_animation != "DashEnd" and last_animation != "StaffDash" and last_animation != "DashEndDescend":
		if y_velocity < -950.0:
			change_animation("JumpStart", false, MOVEMENT_TRACK_INDEX)
		elif y_velocity < -APEX_RANGE:
			change_animation("Ascend", true, MOVEMENT_TRACK_INDEX)
		elif y_velocity > APEX_RANGE:
			change_animation("Descend", true, MOVEMENT_TRACK_INDEX)
		else:
			change_animation("Apex", false, MOVEMENT_TRACK_INDEX)

func hide_player(b : bool):
	visible = not b

func death():
	change_animation("Death", false, 9)

func ranged_attack():
	a.set_animation("RangedAttackForward", false, ATTACK_TRACK_INDEX)
	a.add_empty_animation(ATTACK_TRACK_INDEX, 0.3, 0.2)

func _on_animation_event(_spine_sprite, _animation_state, _track_entry, event : SpineEvent):
	if event.get_data().get_event_name() == "Step":
		Audio.footstep()
