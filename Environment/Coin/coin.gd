extends Area2D
class_name Coin

@onready var sprite : SpineSprite = $CoinSprite

@export var FLOAT_SPEED : float = 0.5
@export var FLOAT_HEIGHT : float = 20.0
@export var FOLLOW_DISTANCE : float = 200.0
@export var MAX_FOLLOW_DISTANCE : float = 1000.0
@export var FOLLOW_SPEED : float = 2.0
@export var COIN_ID : int = -1

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@export var sound : AudioStream

var float_cycle : float = 0.0
var p : PlayerCharacter = null

func _ready():
	if not ScoreManager.particles_enabled:
		$GPUParticles2D.emitting = false
	if ScoreManager.coinArray.find(COIN_ID) != -1:
		queue_free()

func _process(delta):
	if p:
		follow(delta)
	else:
		idle(delta)

func follow(delta : float) -> void:
	var distance : float = (p.global_position - global_position).length()
	if distance > FOLLOW_DISTANCE:
		position += (distance) * (p.global_position - global_position).normalized() * delta * FOLLOW_SPEED
	elif distance > MAX_FOLLOW_DISTANCE:
		position += (distance - MAX_FOLLOW_DISTANCE) * (p.global_position - global_position).normalized()
	else: 
		idle(delta)

func idle(delta : float) -> void:
	float_cycle += delta * FLOAT_SPEED
	if float_cycle > 1.0:
		float_cycle -= 1.0
	sprite.position.y = sin(float_cycle * 2 * PI) * FLOAT_HEIGHT
	sprite.position.x = sin(float_cycle * 4 * PI) * FLOAT_HEIGHT / 2.0

func _on_body_entered(body : PlayerCharacter):
	p = body
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound
	s.volume_db = 0
	get_tree().current_scene.add_child(s)
