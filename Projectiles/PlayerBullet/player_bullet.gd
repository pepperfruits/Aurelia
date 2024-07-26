extends Hitbox
class_name Projectile

@export var velocity : Vector2 = Vector2(3000.0,0)
@onready var Sprite : Sprite2D = $Sprite
@onready var Collision : CollisionShape2D = $CollisionShape2D
var sender = null

func _ready():
	if velocity.x < 0:
		Sprite.scale.x *= -1
		Collision.position.x *= -1

func _process(delta):
	position += velocity * delta

func _on_body_entered(_body):
	self.queue_free()
