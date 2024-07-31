extends Hitbox
class_name Projectile

@export var velocity : Vector2 = Vector2(3000.0,0)
@export var acceleration : Vector2 = Vector2(1000.0,0)
@export var bulletParticles : PackedScene
@onready var Light : PointLight2D = $PointLight2D
@onready var Sprite : Sprite2D = $Sprite
@onready var Collision : CollisionShape2D = $CollisionShape2D
@onready var Particles : GPUParticles2D = $GPUParticles2D
var sender = null

func _ready():
	if not ScoreManager.particles_enabled or true: # ALERT this disables all particles for this permanently!
		Particles.emitting = false
	
	if velocity.x < 0:
		Light.position.x *= -1
		Light.scale.x *= -1
		Particles.position.x *= -1
		Sprite.scale.x *= -1
		Sprite.position.x *= -1
		Collision.position.x *= -1
		acceleration.x *= -1

func _process(delta):
	if velocity.length() >= 3000:
		velocity += acceleration * 0.5 * delta
	position += velocity * delta
	if velocity.length() >= 3000:
		velocity += acceleration * 0.5 * delta

func _on_body_entered(_body):
	particles()
	self.queue_free()

func _on_area_entered(_area):
	particles()
	self.queue_free()

func particles():
	if ScoreManager.particles_enabled:
		if bulletParticles:
			var part = bulletParticles.instantiate()
			get_tree().current_scene.add_child(part)
			part.global_position = global_position
