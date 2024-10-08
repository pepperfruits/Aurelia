extends Area2D
class_name Crystal

var p : PlayerCharacter = null
@onready var PointerSprite : Sprite2D = $PointerSprite
@onready var Sprite : Sprite2D = $Crystal

## particles that you make when you teleport
@export var TeleportParticles : PackedScene = preload("res://Particles/TeleportParticles/teleport_particles.tscn")

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@export var sound1 : AudioStream
@export var sound2 : AudioStream

func _process(_delta):
	if p:
		var h = p.InputHandler.get_horizontal_input()
		var v = p.InputHandler.get_vertical_input()
		if h or v:
			var direction : Vector2 = Vector2(h, -v)
			PointerSprite.position = (direction.normalized() * 300.0)
			PointerSprite.rotation = direction.angle()

func _on_area_entered(bullet : Projectile):
	p = bullet.sender
	
	if ScoreManager.particles_enabled:
		var particles = TeleportParticles.instantiate()
		add_child(particles)
		particles.global_position = p.global_position
	
	
	teleport_player()
	p.enter_crystal(self)
	set_pointer(true)
	bullet.queue_free()

func teleport_player():
	p.global_position = global_position
	p.set_player_velocity(Vector2(0,0))
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound1
	s.volume_db = 3
	get_tree().current_scene.add_child(s)

func set_pointer(b : bool) -> void:
	PointerSprite.visible = b

func use():
	set_pointer(false)
	p = null
	
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound2
	s.volume_db = 3
	get_tree().current_scene.add_child(s)


func _on_flashing_timer_timeout():
	if p:
		if Sprite.modulate == Color.GRAY:
			Sprite.modulate = Color.WHITE
		else:
			Sprite.modulate = Color.GRAY
	else:
		Sprite.modulate = Color.WHITE


func _on_body_entered(player : PlayerCharacter):
	p = player
	
	if ScoreManager.particles_enabled:
		var particles = TeleportParticles.instantiate()
		add_child(particles)
		particles.global_position = p.global_position
	
	
	teleport_player()
	p.enter_crystal(self)
	set_pointer(true)
