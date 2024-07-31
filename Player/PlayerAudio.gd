extends Node
class_name PlayerAudio

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@export var dash_sfx_1 : AudioStream
@export var dash_sfx_2 : AudioStream

@export var dying_sfx : AudioStream

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
