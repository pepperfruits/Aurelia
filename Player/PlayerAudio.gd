extends Node
class_name PlayerAudio

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@export var dash_sfx_1 : AudioStream
@export var dash_sfx_2 : AudioStream

@export var dying_sfx : AudioStream

@export var footstep_sfx_1 : AudioStream
@export var footstep_sfx_2 : AudioStream
@export var footstep_sfx_3 : AudioStream
@export var footstep_sfx_4 : AudioStream

@export var grapple_sfx : AudioStream

@export var jump_sfx : AudioStream

@export var attack_sfx : AudioStream

func play(sound : AudioStream, db : float):
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound
	s.volume_db = db
	add_child(s)

func death():
	play(dying_sfx, -5)

func dash():
	match rng.randi_range(0,1):
		0:
			play(dash_sfx_1, 0)
		1:
			play(dash_sfx_2, 0)

func footstep():
	var volume : float = -14
	match rng.randi_range(0,3):
		0:
			play(footstep_sfx_1, volume)
		1:
			play(footstep_sfx_2, volume)
		2:
			play(footstep_sfx_3, volume)
		3:
			play(footstep_sfx_4, volume)

func grapple():
	play(grapple_sfx, -5)

func jump():
	play(jump_sfx, -15)

func attack():
	play(attack_sfx, 0)
