extends Hitbox
class_name Projectile

@export var velocity : Vector2 = Vector2(3000.0,0)
@export var acceleration : Vector2 = Vector2(1000.0,0)
@export var bulletParticles : PackedScene
@onready var Sprite : Sprite2D = $Sprite
@onready var Collision : CollisionShape2D = $CollisionShape2D
@onready var Particles : GPUParticles2D = $GPUParticles2D
var sender = null

func _ready():
	if velocity.x < 0:
		Sprite.scale.x *= -1
		Collision.position.x *= -1
		Particles.position.x *= -1
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

func particles():
	var part = bulletParticles.instantiate()
	get_tree().current_scene.add_child(part)
	part.global_position = global_position
